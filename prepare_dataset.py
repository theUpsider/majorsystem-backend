import re
import csv
import argparse
import json


def load_substitution_dict(json_file):
    with open(json_file, "r", encoding="utf-8") as file:
        return json.load(file)


def word_to_number(word, subst_dict):
    word = word.lower()
    for key, value in subst_dict.items():
        word = word.replace(key, value)
    return "".join(char for char in word if char.isdigit())


def process_file(input_file, output_file, subst_dict):
    with open(input_file, "r", encoding="utf-8") as infile, open(
        output_file, "w", newline="", encoding="utf-8"
    ) as outfile:
        writer = csv.writer(outfile)
        writer.writerow(["word", "number"])  # Write header

        for line in infile:
            words = re.findall(r"\b\w+\b", line.strip())
            for word in words:
                number = word_to_number(word, subst_dict)
                if number:  # Only write if there's a number
                    writer.writerow([word, number])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process a file for the major system.")
    parser.add_argument("input_file", help="The input file containing words.")
    parser.add_argument("output_file", help="The output CSV file to save the results.")
    parser.add_argument(
        "json_file", help="The JSON file containing the substitution dictionary."
    )
    args = parser.parse_args()

    subst_dict = load_substitution_dict(args.json_file)
    process_file(args.input_file, args.output_file, subst_dict)
    print(f"Processed {args.input_file} and created {args.output_file}")
