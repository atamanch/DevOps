# Specify the file you would like to read
input_file = "test_log.txt"

# Create empty list which will be populated based on below phrases 
filtered_lines = []
# Specify which keywords constitute an important line in the file
# These are case insensitive
keep_phrases = ["critical",
              "warning",
              "error"]

# Loop through each line in input_file
with open('{}'.format(input_file)) as file:
    # f = f.readlines()
    for line in file:
        for phrase in keep_phrases:
            # .lower() used to ensure case insensitivity
            if phrase in line.lower():
                filtered_lines.append(line)
                break

# Print the lines which matched the keep_phrases
print(filtered_lines)
