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
    let _ = stdin()
        .read_to_end(&mut almanac)?;

    let almanac = String::from_utf8(almanac)?;
    let mut groups = almanac.split("\n\n");

    let seeds = groups
        .next()
        .ok_or("no groups")?
        .split(' ')
        .filter_map(|word| word.parse::<u64>().ok());
    let groups = groups;

    let mut maps: [Vec<_>; 7] = Default::default();

    for group in groups {
        let mut lines = group.split("\n");
        let name = lines
            .next()
            .ok_or("no lines")?;
        let lines = lines;

        let map = match name {
            "seed-to-soil map:"            => &mut maps[0],
            "soil-to-fertilizer map:"      => &mut maps[1],
            "fertilizer-to-water map:"     => &mut maps[2],
            "water-to-light map:"          => &mut maps[3],
            "light-to-temperature map:"    => &mut maps[4],
            "temperature-to-humidity map:" => &mut maps[5],
            "humidity-to-location map:"    => &mut maps[6],
            _ => unreachable!("invalid map name: {}", name),
        };

        for line in lines {
            if line.is_empty() {
                continue;
            }

            let &[dst, src, len] = line
                .split_whitespace()
                .map(|word| word.parse::<u64>().unwrap_or(0))
                .collect::<Vec<_>>()
                .as_slice()
            else { unreachable!("invalid format: {}", line) };

            map.push(Map { dst, src, len });
        }
    }
    let maps = maps;

    let closest = seeds.map(|seed| {
        maps.iter()
            .fold(seed, |val, maps| {
                maps.iter()
                    .find_map(|map| map.map(val))
                    .unwrap_or(val)
            })
    })
    .min()
    .ok_or("no seeds")?;

    println!("{}", closest);
    Ok(())
}
