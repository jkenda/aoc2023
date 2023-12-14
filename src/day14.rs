use std::io::{stdin, Read};
use std::fmt::Display;

#[derive(Debug, PartialEq)]
enum Space {
    Empty,
    MovableRock,
    ImmovableRock,
}

impl Display for Space {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Space::Empty => write!(f, "."),
            Space::MovableRock => write!(f, "O"),
            Space::ImmovableRock => write!(f, "#"),
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut map = Vec::with_capacity(640_000);
    let _ = stdin().read_to_end(&mut map);

    let map = String::from_utf8(map)?;

    let mut platform = map
        .trim()
        .split('\n')
        .map(|line| line.chars()
            .map(|c| match c {
                '.' => Space::Empty,
                'O' => Space::MovableRock,
                '#' => Space::ImmovableRock,
                _ => panic!("invalid symbol: {}", c),
            })
            .collect::<Vec<_>>())
        .collect::<Vec<_>>();
    let height = platform.len();

    let movable_rocks = platform
        .iter()
        .enumerate()
        .map(|(i, line)| line
            .iter()
            .enumerate()
            .filter_map(move |(j, space)| match space {
                Space::MovableRock => Some((i, j)),
                _ => None,
            }))
        .flatten()
        .collect::<Vec<_>>();

    // slide movable rocks north until
    // they meet a rock or a wall
    let movable_rocks = movable_rocks
        .into_iter()
        .map(move |(i, j)| {
            let prev_i = i;

            let non_empty = (0..i)
                .rev()
                .find(|i| platform[*i][j] != Space::Empty);
            let new_i = match non_empty {
                Some(i) => i + 1,
                None => 0,
            };

            if new_i != prev_i {
                platform[new_i][j] = Space::MovableRock;
                platform[prev_i][j] = Space::Empty;
            }
            (new_i, j)
        })
        .collect::<Vec<_>>();

    let sum = movable_rocks
        .into_iter()
        .map(|(i, _)| height - i)
        .sum::<usize>();

    println!("{:?}", sum);

    Ok(())
}
