def task(x): # task function to check result.
    if x >= 0: # because ** operation doesn't work with negative numbers (but our program works with negative numbers too,
        # because we can calculate the 5th degree of negative number.)
        return x ** 0.2
    return -(-x) ** 0.2

input_data = [-32, -2, -1, 0, 1, 2, 32] # our tests from .asm file.
output_data = [task(x) for x in input_data]
for i in range(len(input_data)): # printing result.
    print('----------------')
    print('Test:', input_data[i])
    print('Result:', output_data[i])
