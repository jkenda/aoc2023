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
    row: usize,
    col: usize,
}

fn is_empty(space: &Vec<Vec<Space>>, which: Which, i: usize) -> bool {
    match which {
        Which::Row => space[i].iter().all(|s| *s == Space::Empty),
        Which::Col => space.iter().all(|row| row[i] == Space::Empty),
    }
}

fn dist(empty_rows: &[usize], empty_cols: &[usize], a: &Coord, b: &Coord) -> usize {
    // sort rows and cols
    let mut rows = [a.row, b.row];
    let mut cols = [a.col, b.col];
    rows.sort();
    cols.sort();

    // count empty rows as if they were one million times larger
    let mut row_sum: usize = 0;
    for row in rows[0]..rows[1] {
        row_sum += if empty_rows.contains(&row) { 1_000_000 } else { 1 };
    }

    // count empty columns as if they were one million times larger
    let mut col_sum: usize = 0;
    for col in cols[0]..cols[1] {
        col_sum += if empty_cols.contains(&col) { 1_000_000 } else { 1 };
    }

    col_sum + row_sum
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

    let empty_rows = (0..space.len())
        .filter(|&i| is_empty(&space, Which::Row, i))
        .collect::<Vec<_>>();
    let empty_cols = (0..space[0].len())
        .filter(|&i| is_empty(&space, Which::Col, i))
        .collect::<Vec<_>>();

    // get locations of galaxies
    let loc = space.iter().enumerate()
        .fold(Vec::new(), |locations, (i, row)| {
            row.iter().enumerate()
                .fold(locations, |mut locations, (j, space)| {
                    if *space == Space::Galaxy {
                        locations.push(Coord{ row: i, col: j });
                    };
                    locations
                })
        });

    // find sum of distances betewn each pair of galaxies
    let sum = (0..loc.len())
        .map(|i| {
            (i+1..loc.len())
                .map(|j| dist(&empty_rows, &empty_cols, &loc[i], &loc[j]))
                .sum::<usize>()
        })
        .sum::<usize>();

    println!("{sum}");
    
    Ok(())
}
