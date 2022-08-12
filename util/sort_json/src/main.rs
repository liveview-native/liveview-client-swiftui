use std::env::args;
use std::fs::write;
use std::fs::File;
use std::io::BufReader;
use walkdir::WalkDir;

fn main() {
    for entry in WalkDir::new(args().next().expect("directory path")) {
        let dirent = entry.unwrap();
        let path = dirent.path();
        if !path
            .extension()
            .map(|ext| ext.eq_ignore_ascii_case("json"))
            .unwrap_or(false)
        {
            continue;
        }
        let source = File::open(path).unwrap();
        let mut reader = BufReader::new(source);
        let mut out = Vec::new();
        jsonxf::pretty_print_stream(&mut reader, &mut out).unwrap();
        write(path, out).unwrap();
    }
}
