// Compile:
//     dotnet build -c Release
// Run:
//     ./bin/Release/net7.0/13 < input.txt
// Compiler version:
//     dotnet --version
//     7.0.100

open System

let input = Console.In.ReadToEnd().Trim()

type SyntaxNode() =
    [<DefaultValue>] val mutable public next: option<SyntaxNode>

type ParsedList(contents) =
    inherit SyntaxNode()
    member x.contents: list<SyntaxNode> = contents

type ParsedNumber(value) =
    inherit SyntaxNode()
    member x.value: int = value

let rec printNode (n: SyntaxNode) : string =
    match n with
    | :? ParsedList as l ->
        let c = l.contents |> Seq.map printNode
        "[" + String.Join (",", c) + "]"
    | :? ParsedNumber as n -> n.value.ToString()
    | _ -> raise (NotSupportedException "Unhandled node type")

let rec parseNode (value: string) : SyntaxNode * string =
    match value[0] with
        | '[' -> parseList value
        | _ -> parseNumber value

and parseNumber (value: string) : SyntaxNode * string =
    let digitChars = value.ToCharArray()
                        |> Array.takeWhile Char.IsAsciiDigit
                        |> String
    let number = Int32.Parse(digitChars)
    let remaining = value.Substring(digitChars.Length)
    (ParsedNumber(number), remaining)

and parseList (value: string) : SyntaxNode * string =
    let mutable children = []
    let mutable remaining = value.Substring(1) // consume '['

    // This could surely be done with some HOF :(
    while remaining[0] <> ']' do
        if remaining[0] = ',' then
            remaining <- remaining.Substring(1) // consume ','
        else
            let (child, nextRemaining) = parseNode remaining
            remaining <- nextRemaining
            children <- children @ [child]

    remaining <- remaining.Substring(1) // consume ']'

    (ParsedList(children), remaining)


let rec bindChildren (parent: option<SyntaxNode>, children: list<SyntaxNode>) : unit =
    match children with
    | [] -> ()
    | [last] ->
        match parent with
        | Some(p) -> last.next <- p.next
        | _ -> ()
        ()
    | head :: next :: rest ->
        head.next <- Some(next)
        bindChildren (parent, next::rest)
        ()

let bindPacket (node: SyntaxNode, parent: option<SyntaxNode>) : SyntaxNode =
    match parent with
    | Some(p) -> node.next <- p.next
    | _ -> ()

    match node with
    | :? ParsedNumber as number ->
        number.next <- parent
        number
    | :? ParsedList as list ->
        bindChildren (parent, list.contents)
        list
    | _ -> raise (NotSupportedException "Unhandled node type")

let readPacket (line: string) =
    let (root, _) = parseList line
    bindPacket (root, None)

let rec compareNodes (left: SyntaxNode, right: SyntaxNode) : int =
    match left, right with
    | (:? ParsedNumber as l), (:? ParsedNumber as r) ->
        r.value.CompareTo(l.value)

    | (:? ParsedList as l), (:? ParsedList as r) ->

        let firstComparisonNot0 =
            Seq.zip l.contents r.contents
            |> Seq.map compareNodes
            |> Seq.skipWhile ((=) 0)
            |> Seq.tryHead

        match firstComparisonNot0 with
        | Some(r) -> r
        | None ->
            // l and r were equal, at least for the part that was compared
            // l or r might be longer than the other one
            // the result now depends on that.
            // Excerpt from task:
            // If the left list runs out of items first, the inputs are in the right order.
            // If the right list runs out of items first, the inputs are not in the right order.
            // If the lists are the same length and no comparison makes a decision about the order, continue checking the next part of the input.

            // This sounds like a compareTo based on length!
            r.contents.Length.CompareTo(l.contents.Length)

    | (:? ParsedNumber as l), (:? ParsedList as r) ->
        let adhocLeft = ParsedList([l])
        adhocLeft.next <- l.next
        compareNodes (adhocLeft, r)

    | (:? ParsedList as l), (:? ParsedNumber as r) ->
        let adhocRight = ParsedList([r])
        adhocRight.next <- r.next
        compareNodes (l, adhocRight)

    | _ -> raise (NotSupportedException "Unhandled node type")


let packetPairs = input.Split("\n\n")
                    |> Seq.map (
                        fun line ->
                            let pair = line.Split("\n")
                                        |> Seq.map readPacket
                                        |> Array.ofSeq
                            (pair[0], pair[1])
                    ) |> Array.ofSeq

let comparedNodes = packetPairs |> Seq.map compareNodes
let part1 = comparedNodes
                |> Seq.mapi (fun i cmp -> if cmp > 0 then i + 1 else 0)
                |> Seq.sum

printf "Sum of one-based indexes of pairs in correct order; Part 1: %d\n" part1

let dividers = [ "[[2]]" ; "[[6]]" ]
let dividerPackets = dividers |> Seq.map readPacket
let inputPackets = input.Split("\n")
                    |> Seq.filter ((<>) "")
                    |> Seq.map readPacket

let part2Packets = Seq.concat [ inputPackets ; dividerPackets ]
                    |> Array.ofSeq
                    |> Array.sortWith (fun a b -> compareNodes (b, a)) // Swapped for reverse order

let resultLines = part2Packets |> Seq.map printNode |> Array.ofSeq

let part2 =
    dividers
    |> Seq.map (fun divider ->
        let index = resultLines |> Array.findIndex ((=) divider)
        index + 1
    ) |> Seq.fold (*) 1


printf "One-based indexes of divisor packets multiplied; Part 2: %d\n" part2
