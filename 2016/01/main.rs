use std::collections::HashSet;
use std::fs;
use std::env;
use std::ops;

mod util;

// type Number = u16;
// type Product = u64;

// type Pair = (Number, Number);
// type Triplet = (Number, Number, Number);

// fn pair_with_sum(numbers: &Vec<Number>, sum: Number) -> Pair {
//   let mut others: HashSet<Number> = HashSet::new();
//   for i in 1..numbers.len() {
//     others.insert(numbers[i]);
//   }
//   for i in 0..(numbers.len() - 1) {
//     if others.contains(&(sum - numbers[i])) {
//       return (numbers[i], sum - numbers[i]);
//     }
//   }
//   panic!("Pair not found");
// }

// fn triplet_with_sum(numbers: &Vec<Number>, sum: Number) -> Triplet {
//   for i in 0..numbers.len() {
//     let mut j = i + 1;
//     let mut k = numbers.len() - 1;
//     while j < k {
//       let total = numbers[i] + numbers[j] + numbers[k];
//       if total == sum {
//         return (numbers[i], numbers[j], numbers[k]);
//       } else if total < sum {
//         j += 1
//       } else {
//         k -= 1
//       }
//     }
//   }
//   panic!("Triplet not found")
// }

#[derive(Copy, Clone, Eq, Hash)]
struct Complex {
  real: i32,
  imag: i32,
}

impl ToString for Complex {
  fn to_string(&self) -> String {
    if self.imag == 0 {
      return self.real.to_string();
    } else if self.real == 0 {
      return format!("{}i", self.imag);
    } else {
      let sign = if self.imag < 0 { "-" } else { "+" };
      return format!("{} {} {}i", self.real, sign, self.imag.abs());
    }
  }
}

impl PartialEq for Complex {
  fn eq(&self, rhs: &Complex) -> bool {
    return self.real == rhs.real && self.imag == rhs.imag;
  }
}

impl ops::Add<Complex> for Complex {
  type Output = Complex;

  fn add(self, rhs: Complex) -> Complex {
    return Complex { real: self.real + rhs.real, imag: self.imag + rhs.imag };
  }
}

impl ops::Mul<i32> for Complex {
  type Output = Complex;

  fn mul(self, rhs: i32) -> Complex {
    return Complex { real: self.real * rhs, imag: self.imag * rhs };
  }
}

impl ops::Mul<Complex> for Complex {
  type Output = Complex;

  fn mul(self, rhs: Complex) -> Complex {
    return Complex {
      real: self.real * rhs.real - self.imag * rhs.imag,
      imag: self.imag * rhs.real + self.real * rhs.imag
    };
  }
}

struct Day1Solution {
  instructions: Vec<String>
}

impl util::Solution for Day1Solution {
  fn part1_result(&self) -> String {
    let mut position = Complex { real: 0, imag: 0 };
    let mut bearing = Complex { real: 0, imag: 1 };
    for instruction in &self.instructions {
      let direction = &instruction[0..1];
      let magnitude = instruction[1..].parse::<i32>().unwrap();
      let imag = if direction == "R" { -1 } else { 1 };
      bearing = bearing * Complex { real: 0, imag: imag };
      position = position + bearing * magnitude;
    }

    return (position.real.abs() + position.imag.abs()).to_string();
  }

  fn part2_result(&self) -> String {
    let mut position = Complex { real: 0, imag: 0 };
    let mut bearing = Complex { real: 0, imag: 1 };
    let mut visited: HashSet<Complex> = HashSet::new();
    visited.insert(position);
    for instruction in &self.instructions {
      let direction = &instruction[0..1];
      let magnitude = instruction[1..].parse::<i32>().unwrap();
      let imag = if direction == "R" { -1 } else { 1 };
      bearing = bearing * Complex { real: 0, imag: imag };
      for i in 0..magnitude {
        position = position + bearing;
        if visited.contains(&position) {
          return (position.real.abs() + position.imag.abs()).to_string();
        } else {
          visited.insert(position);
        }
      }
    }
    panic!("Not found")
  }
}

fn main() {
  let mut instructions: Vec<String> = Vec::new();
  let contents = fs::read_to_string("./2016/01/input.txt").expect("File not found");
  for line in contents.lines() {
    for inst in line.split(", ") {
      instructions.push(inst.to_string());
    }
  }

  let solution = Day1Solution { instructions: instructions };
  let executor = util::Executor::new(&solution as &util::Solution);
  let args = env::args().collect();
  executor.run(args);
}
