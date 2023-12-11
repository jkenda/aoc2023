use std::io::{stdin, Read};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
struct Range {
    start: u64,
    end: u64,
}
impl Range {
    fn new(start: u64, len: u64) -> Self {
        Self { start, end: start + len }
    }

    fn len(&self) -> u64 {
        self.end - self.start
    }

    fn contains(&self, other: &Range) -> bool {
        (self.start..self.end).contains(&other.start)
        && (self.start..=self.end).contains(&other.end)
    }
}
impl Ord for Range {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.start.cmp(&other.start)
    }
}
impl PartialOrd for Range {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.cmp(other))
    }
}

struct Map {
    dst: Range,
    src: Range,
}

impl Map {
    fn new(dst: u64, src: u64, len: u64) -> Self {
        Self {
            dst: Range { start: dst, end: dst + len },
            src: Range { start: src, end: src + len },
        }
    }

    fn map(&self, ranges: &[Range]) -> (Vec<Range>, Vec<Range>) {
        let (mapped, not_mapped): (Vec<_>, Vec<_>) =
         ranges.iter().map(|range| {
             if *range == self.src {
                 (vec![self.dst], vec![])
             } else if self.src.contains(range) {
                 let mapped = Range {
                     start: range.start - self.src.start + self.dst.start,
                     end: range.end - self.src.start + self.dst.start,
                 };
                 (vec![mapped], vec![])
             } else if range.contains(&self.src) {
                 let mapped = Range { start: self.dst.start, end: self.dst.end };
                 let left = Range { start: range.start, end: self.src.start };
                 let right = Range { start: self.src.end, end: range.end };
                 (vec![mapped], vec![left, right])
             } else if (self.src.start..self.src.end).contains(&range.start) {
                 let mapped = Range {
                     start: range.start - self.src.start + self.dst.start,
                     end: self.dst.end,
                 };
                 let right = Range { start: self.src.end, end: range.end };
                 (vec![mapped], vec![right])
             } else if (self.src.start..self.src.end).contains(&range.end) {
                 let mapped = Range {
                     start: self.dst.start,
                     end: range.end - self.src.start + self.dst.start,
                 };
                 let left = Range { start: range.start, end: self.src.start };
                 (vec![mapped], vec![left])
             } else {
                 (vec![], vec![*range])
             }
        })
        .unzip();
        (mapped.combine(), not_mapped.combine())
    }
}

trait Combine {
    fn combine(self) -> Vec<Range>;
}

impl Combine for Vec<Vec<Range>> {
    fn combine(self) -> Vec<Range> {
        let mut combined: Vec<Range> = self.into_iter()
            .flatten()
            .fold(vec![], |mut acc, new| {
                if new.len() > 0 && !acc.iter().any(|r| r.contains(&new)) {
                    acc.push(new);
                };
                acc
            });

        let mut combine = vec![];
        let mut delete = vec![];

        for (i1, r1) in combined.clone().iter().enumerate() {
            for r2 in combined.clone() {
                if *r1 != r2 && r1.start < r2.start
                    && r1.end > r2.end && r2.start < r1.end
                {
                    combine.push((i1, r2.end));
                    delete.push(r2);
                }
            }
        }

        for (i, end) in combine {
            combined[i].end = end;
        }

        combined.retain(|r| !delete.contains(&r));
        combined
    }
}

impl Combine for (Vec<Range>, Vec<Range>) {
    fn combine(self) -> Vec<Range> {
        let mut new = self.0.clone();
        self.1.iter()
            .for_each(|range| {
                if !new.iter().any(|r| r.contains(range)) {
                    new.push(*range);
                }
            });
        new
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
        .filter_map(|word| word.parse::<u64>().ok())
        .collect::<Vec<_>>();
    let seeds = seeds
        .chunks(2)
        .map(|range| match range {
            &[start, len] => Range::new(start, len),
            _ => panic!("invalid format: {:?}", range),
        });

    let groups = groups.map(|group| {
        let mut lines = group
            .trim()
            .split("\n");
        let _name = lines
            .next()
            .unwrap_or("");
        let lines = lines;

        lines.map(|line| {
            let [dst, src, len] = line
                .split_whitespace()
                .map(|word| word.parse::<u64>().unwrap_or(0))
                .collect::<Vec<_>>()[..]
            else { panic!("invalid format: {}", line) };

            Map::new(dst, src, len)
        })
        .collect::<Vec<_>>()
    })
    .collect::<Vec<_>>();

    let closest = seeds.flat_map(|seed| {
        groups.iter()
            .fold(vec![seed], |ranges, group| {
                group.iter()
                    .fold((vec![], ranges), |(mut mapped, not_mapped), map| {
                        let (mut m, not_mapped) = map.map(&not_mapped);
                        mapped.append(&mut m);
                        (mapped, not_mapped)
                    })
                    .combine()
                    .into_iter()
                    .collect::<Vec<_>>()
            })
    })
    .min()
    .ok_or("no seeds")?;

    println!("{:?}", closest.start);
    Ok(())
}
