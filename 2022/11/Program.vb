' Compile:
'     dotnet build -c Release
' Run:
'     ./bin/Release/net7.0/11 < input.txt
' Compiler version:
'     dotnet --version
'     7.0.100

imports System
imports System.Diagnostics
imports System.Linq
imports System.Collections.Generic

module Program

    sub main(args As String())
        dim input = Console.In.ReadToEnd()
        Part1(input)
        Part2(input)
    end sub

    sub Part1(input as String)
        dim monkeys = input _
            .Split(vbLf & vbLf) _
            .Select(function (l) Monkey.Parse(l.Trim())) _
            .ToArray()

        For i = 1 To 20
            For Each monkey in monkeys
                monkey.PerformTurnPart1(monkeys)
            Next
        Next

        dim mostActiveMonkeys = ExtractSolution(monkeys)
        Console.WriteLine($"Number of inspections of most active monkeys; Part 1: {mostActiveMonkeys}")
    end sub

    sub Part2(input as String)
        dim monkeys = input _
            .Split(vbLf & vbLf) _
            .Select(function (l) Monkey.Parse(l.Trim())) _
            .ToArray()

        ' We'd get enormous numbers when doing the calculation without the reducing step
        ' Luckily, all "tests" are just checks for divisibility by a number $d$
        ' We're even more lucky, all $d$'s are prime numbers! Instead of using the LCM, we can just use the product of all $d$s
        dim ringModulus = monkeys.Select(function (m) m.Test).Aggregate(1, function (acc, i) acc * i)

        For i = 1 To 10000
            For Each monkey in monkeys
                monkey.PerformTurnPart2(monkeys, ringModulus)
            Next
        Next

        dim mostActiveMonkeys = ExtractSolution(monkeys)
        Console.WriteLine($"Number of inspections of most active monkeys without stress relief; Part 2: {mostActiveMonkeys}")
    end sub

    function ExtractSolution(monkeys as Monkey())
        return monkeys _
                .Select(function (m) m.Inspections) _
                .OrderDescending() _
                .Take(2) _
                .Aggregate(1L, function (acc, i) acc * i)
    end function

end module

class Monkey
    dim items as Queue(of Long)
    dim operationOperator as Char
    dim operationOperand as String
    dim trueTarget as Integer
    dim falseTarget as Integer

    public readonly property Test as Integer
    public property Inspections as Integer = 0

    sub new(items as Long(), operationOperator as Char, operationOperand as String, test as Integer, trueTarget as Integer, falseTarget as Integer)
        me.items = new Queue(of Long)(items)
        me.operationOperator = operationOperator
        me.operationOperand = operationOperand
        me.Test = test
        me.trueTarget = trueTarget
        me.falseTarget = falseTarget
    end sub

    sub PerformTurnPart1(allMonkeys as Monkey())
        ' Step 1: Inspect
        dim newItems = GetInspectedItems()
        Inspections += newItems.length

        ' Step 2: Relief
        items = new Queue(of Long)(
            newItems.Select(function (item) item \ 3)
        )

        ' Step 3: Yeet
        while items.Count > 0
            dim item = items.Dequeue()
            if item mod Test = 0
                allMonkeys(trueTarget).items.Enqueue(item)
            else
                allMonkeys(falseTarget).items.Enqueue(item)
            end if
        end while
    end sub


    sub PerformTurnPart2(allMonkeys as Monkey(), ringModulus as Long)
        ' Step 1: Inspect
        dim newItems = GetInspectedItems()
        Inspections += newItems.length

        ' Step 2: Relief by using "a different method" (see "sub Part2" for more info on that)
        items = new Queue(of Long)(
            newItems.Select(function (item) item mod ringModulus)
        )

        ' Step 3: Yeet
        while items.Count > 0
            dim item = items.Dequeue()
            if item mod Test = 0
                allMonkeys(trueTarget).items.Enqueue(item)
            else
                allMonkeys(falseTarget).items.Enqueue(item)
            end if
        end while
    end sub

    private function GetInspectedItems() as Long()
        return items _
            .Select(function (i)
                dim operand = if(operationOperand = "old", i, Long.Parse(operationOperand))
                select operationOperator
                    case "+": return i + operand
                    case "*": return i * operand
                    case "-": return i - operand
                    case else: throw new NotSupportedException()
                end select
            end function) _
            .ToArray()
    end function

    public shared function Parse(input as String) as Monkey
        dim arr = input _
            .Split(vbLf) _
            .Select(function (l) l.Trim()) _
            .ToArray()

        dim items = arr(1) _
            .Substring("Starting items: ".length) _
            .Split(", ") _
            .Select(function (i) Long.Parse(i)) _
            .ToArray()

        dim op = arr(2).Substring("Operation: new = old ".length)
        dim opOp = op(0)
        dim opOperand = op.Substring(1).Trim().ToLower()

        dim test = Integer.Parse(arr(3).Substring("Test: divisible by ".length))
        dim trueTarget = Integer.Parse(arr(4).Substring("If true: throw to monkey ".length))
        dim falseTarget = Integer.Parse(arr(5).Substring("If false: throw to monkey ".length))

        return new Monkey(items, opOp, opOperand, test, trueTarget, falseTarget)
    end function

    public overrides function ToString() as String
        return $"Items: {String.Join(", ", items)} ({items.Count})"
    end function
end class

