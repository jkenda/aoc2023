use std::io::{stdin, Read};

#[derive(Debug, Clone, PartialEq)]
enum Space {
    Galaxy,
    Empty,
}

enum Which {
    Row,
    Col,
}

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

const MILLION: i64 = 1_000_000;

fn is_empty(space: &Vec<Vec<Space>>, which: Which, i: i64) -> bool {
    match which {
        Which::Row => space[i as usize].iter().all(|s| *s == Space::Empty),
        Which::Col => space.iter().all(|row| row[i as usize] == Space::Empty),
    }
}

fn dist(space: &Vec<Vec<Space>>, a: &Coord, b: &Coord) -> i64 {
    // sort rows and cols
    let mut rows = [a.row, b.row];
    let mut cols = [a.col, b.col];
    rows.sort();
    cols.sort();

    // count empty rows as if they were one million times larger
    let mut row_sum: i64 = 0;
    for row in rows[0]..rows[1] {
        row_sum += if is_empty(space, Which::Row, row) { MILLION } else { 1 };
    }

    // count empty columns as if they were one million times larger
    let mut col_sum: i64 = 0;
    for col in cols[0]..cols[1] {
        col_sum += if is_empty(space, Which::Col, col) { MILLION } else { 1 };
    }

    col_sum.abs() + row_sum.abs()
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut buffer = Vec::with_capacity(640_000);
    let _ = stdin().read_to_end(&mut buffer);
    let buffer = buffer;

    // parse input - get space
    let space: Vec<Vec<Space>> = String::from_utf8(buffer)?
        .trim()
        .split('\n')
        .map(|line| {
            line.chars()
                .map(|c| match c {
                    '#' => Space::Galaxy,
                    _   => Space::Empty,
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();

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
            sum += dist(&space, &loc[i], &loc[j]);
        }
    }

    println!("{sum}");
    
    Ok(())
}
