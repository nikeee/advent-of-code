// Compile:
//     dotnet build -c Release
// Run:
//     ./bin/Release/net7.0/08 < input.txt
// Version:
//     dotnet --version
//     7.0.100

var field = Console.In.ReadToEnd()
    .Trim()
    .Split("\n")
    .Select(line => line.ToCharArray().Select(c => int.Parse(c.ToString())).ToArray())
    .ToArray();

var height = field.Length;
var width = field[0].Length;

var visibleFieldsCount = 0;
for (int y = 0; y < height; ++y)
    for (int x = 0; x < width; ++x)
        if (IsTreeVisible(field, x, y, width, height))
            ++visibleFieldsCount;

Console.WriteLine($"Number of trees visible from outside; Part 1: {visibleFieldsCount}");


var bestTreeScore = -1;
for (int y = 0; y < height; ++y) {
    for (int x = 0; x < width; ++x) {
        var score = GetScenticScoreForTree(field, x, y, width, height);
        if (score > bestTreeScore)
            bestTreeScore = score;
    }
}

Console.WriteLine($"Tree with best view; Part 2: {bestTreeScore}");

bool IsTreeVisible(int[][] field, int x, int y, int width, int height) {
    if (x == 0 || y == 0) {
        return true;
    }
    if (x == width - 1 || y == height - 1) {
        return true;
    }

    var me = field[y][x];

    var visibleFromLeft = field[y][..x].All(treeSize => treeSize < me);
    if (visibleFromLeft) {
        return true;
    }

    var visibleFromRight = field[y][(x + 1)..].All(treeSize => treeSize < me);
    if (visibleFromRight) {
        return true;
    }

    var visibleFromTop = field[..y].Select(row => row[x]).All(treeSize => treeSize < me);
    if (visibleFromTop) {
        return true;
    }

    var visibleFromBottom = field[(y + 1)..].Select(row => row[x]).All(treeSize => treeSize < me);
    if (visibleFromBottom) {
        return true;
    }

    return false;
}

int GetScenticScoreForTree(int[][] field, int x, int y, int width, int height) {
    if (x == 0 || y == 0) {
        return 0;
    }
    if (x == width - 1 || y == height - 1) {
        return 0;
    }

    var me = field[y][x];

    var scoreToLeft = 0;
    for (var xToLeft = x - 1; xToLeft >= 0; --xToLeft) {
        ++scoreToLeft;
        if (field[y][xToLeft] >= me) {
            break;
        }
    }

    var scoreToRight = 0;
    for (var xToRight = x + 1; xToRight < width; ++xToRight) {
        ++scoreToRight;
        if (field[y][xToRight] >= me) {
            break;
        }
    }

    var scoreToTop = 0;
    for (var yToTop = y - 1; yToTop >= 0; --yToTop) {
        ++scoreToTop;
        if (field[yToTop][x] >= me) {
            break;
        }
    }

    var scoreToBottom = 0;
    for (var yToBottom = y + 1; yToBottom < height; ++yToBottom) {
        ++scoreToBottom ;
        if (field[yToBottom][x] >= me) {
            break;
        }
    }

    return scoreToLeft * scoreToRight * scoreToTop * scoreToBottom;
}
