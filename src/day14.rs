use std::{io::{stdin, Read}, error::Error};

#[derive(PartialEq)]
enum Space {
    Empty,
    MovableRock,
    ImmovableRock,
}

fn main() -> Result<(), Box<dyn Error>> {
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
        .flat_map(|(i, line)| line
            .iter()
            .enumerate()
            .filter_map(move |(j, space)| match space {
                Space::MovableRock => Some((i, j)),
                _ => None,
            }))
        .collect::<Vec<_>>();

    // slide movable rocks north until
    // they meet a rock or a wall
    let movable_rocks = movable_rocks
        .into_iter()
        .map(move |(prev_i, j)| {
            let non_empty = (0..prev_i)
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
        });

    let sum = movable_rocks
        .into_iter()
        .map(|(i, _)| height - i)
        .sum::<usize>();

    println!("{:?}", sum);

    Ok(())
}
