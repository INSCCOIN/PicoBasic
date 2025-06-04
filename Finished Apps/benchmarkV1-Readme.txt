# MMBasic CPU Stress Test for Pico Calculator

This is a simple CPU stress test program written in [MMBasic](https://mmbasic.com/) for the PicoMite or compatible Pico-based calculators.

## What It Does

The program repeatedly sums the numbers from 1 to 10,000,000, printing the result and the time taken for each iteration. This puts a sustained computational load on the CPU, useful for testing performance or stability.

## How to Use

1. Copy the contents of `benchmarkV1.bas` to your PicoMite or compatible device running MMBasic.
2. Run the program using the MMBasic interpreter.
3. The program will display the sum and how long each iteration took.
4. To stop the test, press `CTRL+C`.

## Example Output

```
Simple CPU stress test. Press Shift+Esc to stop.
Iteration complete. Sum=50000005000000
Time taken: 2.34 seconds
Press Shift+Esc to stop or wait for the next iteration.
```

## Requirements

- PicoMite or compatible device
- MMBasic firmware

## License

This code is provided as-is for testing and educational purposes.
