import re
with open("diff.txt", "w",encoding="utf-8") as fileOut:

    with open('result.txt', 'r', encoding="utf-16-le") as file1, open('correct.txt', 'r', encoding="utf-16-le") as file2:
        lines1 = [re.sub(r"\s+", "", line) for line in file1.readlines()[2:]]
        lines2 = [re.sub(r"\s+", "", line) for line in file2.readlines()[1:]]

        for i, (line1, line2) in enumerate(zip(lines1, lines2)):
            if line1 != line2:
                print(
                    f"Line {i + 1} is different: {line1} != {line2}", file=fileOut)
