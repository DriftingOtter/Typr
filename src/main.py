#!/usr/bin/python

import sys
import string
import random
import time
import os
import argparse

from rich import print
from rich.traceback import install
from rich.panel import Panel
from rich.console import Console


# Enables Console From Rich
console = Console()
install()



time_START = float()
time_STOP = float()
challengeText = str()
plyr_response = str()



# Setting up run time flags for typr
parser = argparse.ArgumentParser(description="Typr: A Simple Terminal Typing Test", add_help=False)
parser.add_argument("-wc", "--wordcount", type=int, help="Required word count for the test")
parser.add_argument("-wl", "--wordlist", help="Path to the word list file")
parser.add_argument("-h", "--help", action="store_true", help="Show help message")



def generateChallengeText(numOfWords, wordList):
    challengeText = []

    with open(wordList, "r") as currentText:
        lines = currentText.readlines()

    numLines = len(lines)

    for words in range(numOfWords):
        randomLineGen = random.randint(0, numLines - 1)
        challengeText.append(lines[randomLineGen].strip())

    return challengeText



# Converts The Generated ChallengeText List -> String
def conv_LTS(lst):
    strText = " ".join([str(elem) for elem in lst])
    strText = strText.translate({ord(c): " " for c in string.whitespace})

    return str(strText)



def displayChallengeText(challengeText):
    print(
        Panel(
            challengeText,
            title="[bold italic]Typr[/]",
        )
    )



def test():
    global time_START, time_STOP, plyr_response

    time_START = time.monotonic()

    try:
        plyr_response = console.input("[bold blue]> [/]")
    except KeyboardInterrupt:
        sys.exit()

    time_STOP = time.monotonic()

    testResults = [time_START, time_STOP, str(plyr_response)]

    return testResults



def accuracy(plyr_response, challengeText):
    try:
        correctWords = sum(
            1 for word in plyr_response.split() if word in challengeText.split()
        )
        totalWords = len(challengeText.split())
        accuracyPercentage: int = int((correctWords / totalWords) * 100)
    except ZeroDivisionError:
        accuracyPercentage = "INVALID"

    return accuracyPercentage



def timeTaken(time_START, time_STOP):
    try:
        timetaken = int(time_STOP - time_START)
    except ZeroDivisionError:
        timetaken = "INVALID"

    return timetaken



def wordsPerMinute(time_START, time_STOP, plyr_response):
    try:
        wordsTyped = len(plyr_response.split())
        timeTakenInMinutes = (time_STOP - time_START) / 60
        wordsPerMinute = wordsTyped / timeTakenInMinutes
        wordsPerMinute = round(wordsPerMinute)
    except ZeroDivisionError:
        wordsPerMinute = "INVALID"

    return wordsPerMinute



def calculateResults(testResults, challengeText):
    wpm = wordsPerMinute(testResults[0], testResults[1], testResults[2])
    acc = accuracy(testResults[2], challengeText)
    ttk = timeTaken(testResults[0], testResults[1])

    testResults = [acc, ttk, wpm, testResults[2], challengeText]

    return testResults



def displayUserScore(testResults):
    try:
        os.system("clear")

        if testResults[3].strip() == testResults[4].strip() and testResults[3] != "":
            print(
                Panel(
                    f"[bold green]Accuracy: [/]{testResults[0]}%\n[bold yellow]Time Taken: [/]{testResults[1]}s\n[bold purple]Words Per Minute: [/]{testResults[2]}",
                    title="[bold italic green]You Did It! Wanna Do Another ?[/]",
                )
            )

        elif testResults[3].strip() != testResults[4].strip() and testResults[3] != "":
            print(
                Panel(
                    f"[bold green]Accuracy: [/]{testResults[0]}%\n[bold yellow]Time Taken: [/]{testResults[1]}s\n[bold purple]Words Per Minute: [/]{testResults[2]}",
                    title="[bold italic red]Nice Try! Some Mistakes There Though, Wanna Do Another ?[/]",
                )
            )

        else:
            print(
                Panel(
                    '"Practice makes perfect" - Some one smart.',
                    title="[bold italic yellow]Test Invalid, try again.[/]",
                )
            )

    except KeyboardInterrupt:
        sys.exit()



if __name__ == "__main__":
    os.system("clear")


    # Defaults
    wordCount: int = 10



    # Get the directory of the currently executing script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Builds Default Word List Path
    wordList = os.path.join(script_dir, "WordLists", "Loki_Word_List_EN.txt")


    # Collect Given Run-Time Flags
    args = parser.parse_args()



    if args.help:
        os.system('clear')

        print(
            Panel(
                '''[bold italic blue]Typr: A Simple Terminal Typing Test[/]
-----------------------------------

[bold purple]>[/] [green]Available Run-Time Flags[/]
--------------------------

    [italic blue]1.[/] [yellow]-wc[/] <amount> [bold]or[/] [yellow]--wordcount[/] <amount>

    Gives typr a required word count for the test.


    [italic blue]2.[/] [yellow]-h[/] [bold]or[/] [yellow]--help[/]

    Shows this help page.


    [italic blue]3.[/] [yellow]-wl[/] <file path> [bold]or[/] [yellow]--wordlist[/] <file path>

    Gives typr a wanted word list that you want it to 
    use to generate the test.

    The file it self must have each word on a separate 
    line, and should have no additional formatting like 
    numbers, listing, images, or any extra information 
    as it will not be able to parse the required data.

    [blue]ex.[/] [italic yellow]"/home/user/word_list.txt"[/]''',
                title="[bold italic blue]Typr: Manual[/]",
            )
        )
        exit()


    if args.wordcount:
        wordCount = args.wordcount


    if args.wordlist:
        if os.path.exists(args.wordlist):
            wordList = args.wordlist
        else:
            os.system('clear')

            print(
                Panel(
                    "Incorrect Words List Path Given",
                    title="[bold italic red]Invalid Arguments.[/]",
                )
            )
            exit()


    challengeText = conv_LTS(generateChallengeText(wordCount, wordList))
    displayChallengeText(challengeText)
    displayUserScore(calculateResults(test(), challengeText))
