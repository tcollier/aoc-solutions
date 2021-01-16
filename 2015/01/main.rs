use std::fs;
use std::env;

mod util;

const OPEN_PAREN: char = '(';

struct Day1Solution {
    input: String
}

impl util::Solution for Day1Solution {
    fn part1_result(&self) -> String {
        let bytes = self.input.as_bytes();
        let mut floor = 0;
        for i in 0..bytes.len() {
            if (bytes[i] as char) == OPEN_PAREN {
                floor += 1;
            } else {
                floor -= 1;
            }
        }
        return floor.to_string()
    }

    fn part2_result(&self) -> String {
        let bytes = self.input.as_bytes();
        let mut floor = 0;
        for i in 0..bytes.len() {
            if (bytes[i] as char) == OPEN_PAREN {
                floor += 1;
            } else {
                floor -= 1;
            }
            if floor < 0 {
                return (i + 1).to_string();
            }
        }
        panic!("not found");
    }
}

fn main() {
    let mut input: Vec<String> = Vec::new();
    let contents = fs::read_to_string("./2015/01/input.txt").expect("File not found");
    for line in contents.lines() {
        input.push(line.to_string());
    }
    let solution = Day1Solution { input: input[0].to_string() };
    let executor = util::Executor::new(&solution as &util::Solution);
    let args = env::args().collect();
    executor.run(args);
}
