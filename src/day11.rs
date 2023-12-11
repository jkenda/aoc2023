use std::io::{stdin, Read};

#[derive(Clone, PartialEq)]
enum Space { Galaxy, Empty }
enum Which { Row, Col }

#[derive(Debug)]
struct Coord {
    row: i64,
    col: i64,
}

impl Coord {
    fn new(row: usize, col: usize) -> Self {
        Self { row: row as i64, col: col as i64 }
    }
}

fn is_empty(space: &Vec<Vec<Space>>, which: Which, i: usize) -> bool {
    match which {
        Which::Row => space[i].iter().all(|s| *s == Space::Empty),
        Which::Col => space.iter().all(|row| row[i] == Space::Empty),
    }
}

fn insert(space: &mut Vec<Vec<Space>>, which: Which, i: usize) {
    match which {
        Which::Row => space.insert(i, vec![Space::Empty; space[i].len()]),
        Which::Col => {
            for row in space {
                row.insert(i, Space::Empty);
            }
        },
    }
}

fn dist(a: &Coord, b: &Coord) -> i64 {
    (a.row - b.row).abs() + (a.col - b.col).abs()
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut buffer = Vec::with_capacity(640_000);
    let _ = stdin().read_to_end(&mut buffer);
    let buffer = buffer;

    // parse input - get space
    let mut space = String::from_utf8(buffer)?
        .trim()
        .split('\n')
        .map(|line| {
            line.chars()
                .map(|c| match c {
                    '#' => Space::Galaxy,
                    '.' => Space::Empty,
                    _   => panic!("unknown character: {}", c),
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

    // expand empty space
    let mut len = space.len();
    let mut i = 0;
    while i < len {
        if is_empty(&space, Which::Row, i) {
            insert(&mut space, Which::Row, i);
            len += 1;
            i += 1;
        }
        i += 1;
    }

    let mut len = space[0].len();
    let mut i = 0;
    while i < len {
        if is_empty(&space, Which::Col, i) {
            insert(&mut space, Which::Col, i);
            len += 1;
            i += 1;
        }
        i += 1;
    }

    // get locations of galaxies
    let loc = space.iter().enumerate()
        .fold(Vec::new(), |locations, (i, row)| {
            row.iter().enumerate()
                .fold(locations, |mut locations, (j, space)| {
                    if *space == Space::Galaxy {
                        locations.push(Coord::new(i, j));
                    };
                    locations
                })
        });

    // find sum of distances betewn each pair of galaxies
    let mut sum = 0;
    for i in 0..loc.len() {
        for j in i+1..loc.len() {
            sum += dist(&loc[i], &loc[j]);
        }
    }

    println!("{sum}");
    
    Ok(())
}
