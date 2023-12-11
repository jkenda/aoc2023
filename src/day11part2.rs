use std::io::{stdin, Read};

#[derive(Clone, PartialEq)]
enum Space { Galaxy, Empty }

#[derive(Debug)]
struct Coord {
    row: usize,
    col: usize,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut buffer = Vec::with_capacity(640_000);
    let _ = stdin().read_to_end(&mut buffer);

    // parse input - get space
    let space = String::from_utf8(buffer)?
        .trim()
        .split('\n')
        .map(|line| {
            line.chars()
                .map(|c| match c {
                    '#' => Space::Galaxy,
                    '.' => Space::Empty,
                    _   => panic!("invalid character: {}", c),
                })
                .collect::<Vec<_>>()
        })
        .collect::<Vec<_>>();
    let (height, width) = (space.len(), space[0].len());

    let row_is_empty = |i: usize| space[i].iter().all(|s| *s == Space::Empty);
    let col_is_empty = |i: usize| space.iter().all(|row| row[i] == Space::Empty);

    let empty_rows = (0..height)
        .filter(|&i| row_is_empty(i))
        .collect::<Vec<_>>();
    let empty_cols = (0..width)
        .filter(|&i| col_is_empty(i))
        .collect::<Vec<_>>();

    // get locations of galaxies
    let loc = space.iter().enumerate()
        .fold(Vec::new(), |loc, (i, row)| {
            row.iter().enumerate()
                .fold(loc, |mut l, (j, space)| {
                    if *space == Space::Galaxy {
                        l.push(Coord{ row: i, col: j });
                    }; l
                })
        });

    let dist = |a: &Coord, b: &Coord| {
        // sort rows and cols
        let mut rows = [a.row, b.row];
        let mut cols = [a.col, b.col];
        rows.sort();
        cols.sort();

        // count empty rows and columns as if they were
        // a million times larger
        let row_sum = (rows[0]..rows[1])
            .map(|row| if empty_rows.contains(&row) { 1_000_000 } else { 1 })
            .sum::<usize>();
        let col_sum = (cols[0]..cols[1])
            .map(|col| if empty_cols.contains(&col) { 1_000_000 } else { 1 })
            .sum::<usize>();

        row_sum + col_sum
    };

    // find sum of distances betewn each pair of galaxies
    let sum = (0..loc.len())
        .map(|i| {
            (i+1..loc.len())
                .map(|j| dist(&loc[i], &loc[j]))
                .sum::<usize>()
        })
        .sum::<usize>();

    println!("{sum}");
    
    Ok(())
}
