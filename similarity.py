import csv
from collections import defaultdict
import json

# Return the Levenshtein distance between a and b divided by max(a.length, b.length)
def similarity(a, b):
    word = a, b = sorted([a, b], reverse=True)
    m, n = map(len, word)
    if a and b:
        dp = [[0] * n for i in range(2)]
        dp[0][0] = dp[1][0] = int(a[0] != b[0])
        for j in range(1, n):
            dp[0][j] = max(dp[0][j - 1] + int(a[0] != b[j]), j)
        for i in range(1, m):
            dp[1][0] = max(dp[0][0] + int(a[i] != b[0]), i)
            for j in range(1, n):
                dp[1][j] = min(dp[0][j - 1], dp[0][j], dp[1][j - 1]) + 1 if a[i] != b[j] else dp[0][j - 1]
            dp[0] = dp[1][:]
        return 1 - dp[-1][-1] / max(m, n)
    else:
        return 0

# Map each language to its code sample
file_dict = {
    'C': 'kahn.c',
    'Clojure': 'kahn.clj',
    'CoffeeScript': 'kahn.coffee',
    'C++': 'kahn.cpp',
    'C#': 'kahn.cs',
    'Dart': 'kahn.dart',
    'Erlang': 'kahn.erl',
    'Elixir': 'kahn.ex',
    'F#': 'kahn.fs',
    'Go': 'kahn.go',
    'Groovy': 'kahn.groovy',
    'Haskell': 'kahn.hs',
    'Java': 'kahn.java',
    'Julia': 'kahn.jl',
    'JavaScript': 'kahn.js',
    'Kotlin': 'kahn.kt',
    'Lisp': 'kahn.lisp',
    'Lua': 'kahn.lua',
    'Objective-C': 'kahn.m',
    'MATLAB': 'kahn.matlab',
    'OCaml': 'kahn.ml',
    'PHP': 'kahn.php',
    'Perl': 'kahn.pl',
    'PowerShell': 'kahn.ps1',
    'Python': 'kahn.py',
    'R': 'kahn.r',
    'Ruby': 'kahn.rb',
    'Rust': 'kahn.rs',
    'Scala': 'kahn.sc',
    'Bash': 'kahn.sh',
    'Swift': 'kahn.swift',
    'TypeScript': 'kahn.ts',
    'Vim': 'kahn.vim'
}

# Open the CSV
similarity_file = open('similarity.csv', 'w')
writer = csv.writer(similarity_file)
writer.writerow([''] + list(file_dict.keys()))

# For each pair, write the similarity to the CSV
similarity_dict = defaultdict(lambda: defaultdict(int))
for language1, language_file_name1 in file_dict.items():
    language_file1 = open('CodeSamples/' + language_file_name1, 'r')
    code1 = language_file1.read()
    language_file1.close()
    for language2, language_file_name2 in file_dict.items():
        language_file2 = open('CodeSamples/' + language_file_name2, 'r')
        code2 = language_file2.read()
        language_file2.close()
        similarity_dict[language1][language2] = similarity(code1, code2) if language1 != language2 else 1
    writer.writerow([language1] + list(similarity_dict[language1].values()))

# Close the CSV
similarity_file.close()
