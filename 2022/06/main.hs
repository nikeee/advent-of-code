-- Compile:
--     ghc -O3 main.hs
-- Use:
--     ./main < input.txt
-- Version:
-- ghc --version
-- The Glorious Glasgow Haskell Compilation System, version 9.0.2

import Data.List (tails, nub)
import Text.Printf

enumerate = zip [0..]

-- this is a simple sliding window that also has windows less than the desired length at the end
-- We also don't trim off the \n and new line because we should have found a solution before we got there
windows n = map (take n) . tails

countDistinct items = length . nub $ items

findFirstMessageOffset input windowSize = do
    let slidingWindows = windows windowSize input
    let distinctCharsInWindows = map countDistinct slidingWindows
    let distinctCharsWithIndex = enumerate distinctCharsInWindows
    let firstOccurrence = head (filter ((==windowSize) . snd) distinctCharsWithIndex)
    (fst firstOccurrence) + windowSize

main = do
    input <- getContents
    let part1Solution = findFirstMessageOffset input 4
    putStrLn $ "First index of message start (window size 4); Part 1: " ++ (show part1Solution)
    let part2Solution = findFirstMessageOffset input 14
    putStrLn $ "First index of message start (window size 14); Part 2: " ++ (show part2Solution)
