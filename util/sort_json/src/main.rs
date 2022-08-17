use serde_json::from_reader;
use serde_json::Map;
use serde_json::Value;
use std::env::args;
use std::fs::File;
use std::io::BufReader;
use std::io::BufWriter;
use walkdir::WalkDir;

fn main() {
    let mut count = 0;
    let mut args = args();
    args.next(); // skip argv[0]
    for entry in WalkDir::new(args.next().expect("directory path")) {
        let dirent = entry.unwrap();
        let path = dirent.path();
        if !path
            .extension()
            .map(|ext| ext.eq_ignore_ascii_case("json"))
            .unwrap_or(false)
        {
            continue;
        }
        count += 1;
        let source = File::open(path).unwrap();
        let mut value: Value = from_reader(BufReader::new(source)).unwrap();
        sort_objects(&mut value);
        let dest = File::options()
            .write(true)
            .truncate(true)
            .open(path)
            .unwrap();
        serde_json::to_writer_pretty(BufWriter::new(dest), &value).unwrap();
    }
    println!("Sorted {} files", count);
}

fn sort_objects(value: &mut Value) {
    match value {
        Value::Array(vec) => {
            for value in vec.iter_mut() {
                sort_objects(value);
            }
        }
        Value::Object(map) => {
            let mut new_map = Map::with_capacity(map.len());
            // swap so that we have ownership of the old values and can re-use them w/o cloning
            std::mem::swap(map, &mut new_map);
            let mut entries = new_map.into_iter().collect::<Vec<_>>();
            entries.sort_by(|(k1, _), (k2, _)| k1.cmp(k2));
            for (k, mut v) in entries {
                sort_objects(&mut v);
                map.insert(k, v);
            }
        }
        _ => (),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_sort_object() {
        let s = r#"{"b":"","a":""}"#;
        let mut v = serde_json::from_str(s).unwrap();
        sort_objects(&mut v);
        let res = serde_json::to_string(&v).unwrap();
        assert_eq!(res, r#"{"a":"","b":""}"#);
    }
}
