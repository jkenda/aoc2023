use std::io::{stdin, Read};

struct Map {
    dst: u64,
    src: u64,
    len: u64,
}

impl Map {
    fn map(&self, seed: u64) -> Option<u64> {
        if seed >= self.src && seed < self.src + self.len {
            Some(seed - self.src + self.dst)
        } else {
            None
        }
    }
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut almanac = Vec::with_capacity(640_000);
    let _ = stdin().read_to_end(&mut almanac);

    let almanac = String::from_utf8(almanac)?;
    let mut groups = almanac
        .trim()
        .split("\n\n");

    let seeds = groups
        .next()
        .ok_or("no groups")?
        .split(' ')
        .filter_map(|word| word.parse::<u64>().ok());

    let groups = groups.map(|group| {
        let mut lines = group
            .trim()
            .split("\n");
        let _name = lines
            .next()
            .unwrap_or("");
        let lines = lines;

        lines.map(|line| {
            let &[dst, src, len] = line
                .split_whitespace()
                .map(|word| word.parse::<u64>().unwrap_or(0))
                .collect::<Vec<_>>()
                .as_slice()
            else { panic!("invalid format: {}", line) };

            Map { dst, src, len }
        })
        .collect::<Vec<_>>()
    })
    .collect::<Vec<_>>();

    let closest = seeds.map(|seed| {
        groups.iter()
            .fold(seed, |val, group| {
                group.iter()
                    .find_map(|map| map.map(val))
                    .unwrap_or(val)
            })
    })
    .min()
    .ok_or("no seeds")?;

    println!("{}", closest);
    Ok(())
}
