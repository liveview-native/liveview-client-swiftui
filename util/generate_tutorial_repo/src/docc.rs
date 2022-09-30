use std::{collections::HashMap, iter::Peekable, str::Chars};

#[derive(Debug, PartialEq)]
pub enum Node {
    Directive {
        name: String,
        args: HashMap<String, String>,
        children: Vec<Node>,
    },
    Text(String),
    Comment(String),
}

impl Node {
    pub fn is_directive(&self, name: &str) -> bool {
        match self {
            Node::Directive {
                name: ref self_name,
                ..
            } if self_name == name => true,
            _ => false,
        }
    }

    pub fn children(&self) -> &[Node] {
        match self {
            Node::Directive { ref children, .. } => &children,
            _ => &[],
        }
    }
}

pub fn parse(s: &str) -> Node {
    let mut chars = s.chars().peekable();
    skip_whitespace(&mut chars);
    if chars.peek() != Some(&'@') {
        panic!("expected directive at root");
    }
    parse_from_chars(&mut chars)
}

fn parse_from_chars(chars: &mut Peekable<Chars<'_>>) -> Node {
    skip_whitespace(chars);
    match chars.peek().unwrap() {
        '@' => parse_directive(chars),
        _ => parse_text(chars),
    }
}

fn parse_directive(chars: &mut Peekable<Chars<'_>>) -> Node {
    if chars.next() != Some('@') {
        panic!("expected @ at start of directive");
    }

    let mut name = String::new();
    while let Some(c) = chars.peek() {
        if c.is_alphabetic() {
            name.push(*c);
            chars.next();
        } else {
            break;
        }
    }

    if name == "Comment" {
        return parse_comment_directive(chars);
    }

    skip_whitespace(chars);

    let got_paren = chars.peek() == Some(&'(');
    let args = if got_paren {
        chars.next();
        parse_directive_args(chars)
    } else {
        HashMap::new()
    };

    skip_whitespace(chars);

    let mut children: Vec<Node> = vec![];
    if chars.peek() == Some(&'{') {
        chars.next();
        loop {
            skip_whitespace(chars);
            if let Some(c) = chars.peek() {
                if *c == '}' {
                    chars.next();
                    break;
                } else {
                    children.push(parse_from_chars(chars));
                }
            } else {
                panic!("unexpected eof");
            }
        }
    } else {
        if !got_paren {
            panic!("expected ( or {{ after directive name");
        }
    }

    Node::Directive {
        name,
        args,
        children,
    }
}

fn parse_comment_directive(chars: &mut Peekable<Chars<'_>>) -> Node {
    skip_whitespace(chars);
    if chars.next() != Some('{') {
        panic!("expected {{ after @Comment");
    }
    let mut s = String::new();
    while let Some(c) = chars.next() {
        if c == '}' {
            break;
        } else {
            s.push(c);
        }
    }
    Node::Comment(s.trim().to_owned())
}

fn parse_directive_args(chars: &mut Peekable<Chars<'_>>) -> HashMap<String, String> {
    let mut map = HashMap::new();

    loop {
        skip_whitespace(chars);
        if let Some(c) = chars.peek() {
            if *c == ')' {
                chars.next();
                break;
            } else {
                let name = parse_ident(chars);
                if name.is_empty() {
                    panic!("expected directive arg name");
                }
                skip_whitespace(chars);
                if chars.next() != Some(':') {
                    panic!("expected : after directive arg name");
                }
                skip_whitespace(chars);
                let value: String;
                if chars.peek() == Some(&'"') {
                    value = parse_quoted_str(chars);
                } else {
                    value = parse_unquoted_arg(chars);
                }

                map.insert(name, value);

                if chars.peek() == Some(&',') {
                    chars.next();
                }
            }
        } else {
            panic!("unexpected eof");
        }
    }

    map
}

fn parse_ident(chars: &mut Peekable<Chars<'_>>) -> String {
    let mut s = String::new();
    while let Some(c) = chars.peek() {
        if c.is_alphabetic() {
            s.push(*c);
            chars.next();
        } else {
            break;
        }
    }
    s
}

fn parse_quoted_str(chars: &mut Peekable<Chars<'_>>) -> String {
    if chars.next() != Some('"') {
        panic!("expected \"");
    }
    let mut s = String::new();
    let mut prev_was_slash = false;
    while let Some(c) = chars.peek() {
        if *c == '"' && !prev_was_slash {
            chars.next();
            break;
        } else {
            prev_was_slash = *c == '\\';
            s.push(*c);
            chars.next();
        }
    }
    s
}

fn parse_unquoted_arg(chars: &mut Peekable<Chars<'_>>) -> String {
    let mut s = String::new();
    while let Some(c) = chars.peek() {
        if *c == ',' || *c == ')' {
            break;
        }
        s.push(*c);
        chars.next();
    }
    s
}

fn parse_text(chars: &mut Peekable<Chars<'_>>) -> Node {
    skip_whitespace(chars);

    let mut s = String::new();
    while let Some(c) = chars.peek() {
        if *c == '\n' {
            break;
        }
        s.push(*c);
        chars.next();
    }

    Node::Text(s)
}

fn skip_whitespace(chars: &mut Peekable<Chars<'_>>) {
    while let Some(c) = chars.peek() {
        if c.is_whitespace() {
            chars.next();
        } else {
            break;
        }
    }
}

impl Node {
    pub fn depth_first(&'_ self) -> DepthFirstIterator<'_> {
        DepthFirstIterator {
            node: self,
            state: State::Start,
        }
    }
}

pub struct DepthFirstIterator<'a> {
    node: &'a Node,
    state: State<'a>,
}

enum State<'a> {
    Start,
    VisitingChildren(
        std::slice::Iter<'a, Node>,
        Option<Box<DepthFirstIterator<'a>>>,
    ),
    Done,
}

impl<'a> Iterator for DepthFirstIterator<'a> {
    type Item = &'a Node;

    fn next(&mut self) -> Option<Self::Item> {
        match self.state {
            State::Start => {
                match self.node {
                    Node::Directive { children, .. } => {
                        let iter = children.iter();
                        self.state = State::VisitingChildren(iter, None);
                    }
                    _ => {
                        self.state = State::Done;
                    }
                }
                Some(self.node)
            }
            State::VisitingChildren(ref mut iter, ref mut nested_opt) => {
                if let Some(ref mut nested) = nested_opt {
                    let res = nested.next();
                    if res.is_none() {
                        *nested_opt = None;
                        self.next()
                    } else {
                        res
                    }
                } else {
                    if let Some(next) = iter.next() {
                        *nested_opt = Some(Box::new(next.depth_first()));
                    } else {
                        self.state = State::Done;
                    }
                    self.next()
                }
            }
            State::Done => None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_parse_directive_with_args() {
        assert_eq!(
            parse("@Foo(bar: baz, buz: qux)"),
            Node::Directive {
                name: "Foo".into(),
                args: [("bar".into(), "baz".into()), ("buz".into(), "qux".into())]
                    .into_iter()
                    .collect(),
                children: vec![]
            }
        )
    }

    #[test]
    fn test_parse_directive_with_text_children() {
        assert_eq!(
            parse(
                r#"
@Foo {
    bar

    baz
}
                "#
            ),
            Node::Directive {
                name: "Foo".into(),
                args: HashMap::new(),
                children: vec![Node::Text("bar".into()), Node::Text("baz".into()),]
            }
        )
    }

    #[test]
    fn test_parse_directive_with_args_and_text_children() {
        assert_eq!(
            parse(
                r#"
@Foo(bar: baz) {
    qux
}
                "#
            ),
            Node::Directive {
                name: "Foo".into(),
                args: [("bar".into(), "baz".into())].into_iter().collect(),
                children: vec![Node::Text("qux".into())]
            }
        )
    }

    #[test]
    fn test_parse_nested_directives() {
        assert_eq!(
            parse(
                r#"
@Foo {
    @Bar(baz: buz) {
        qux
    }
}
                "#
            ),
            Node::Directive {
                name: "Foo".into(),
                args: HashMap::new(),
                children: vec![Node::Directive {
                    name: "Bar".into(),
                    args: [("baz".into(), "buz".into())].into_iter().collect(),
                    children: vec![Node::Text("qux".into()),]
                }]
            }
        )
    }

    #[test]
    fn test_parse_multiple_children_types() {
        assert_eq!(
            parse(
                r#"
@Foo {
    @Bar()

    baz
}
                "#
            ),
            Node::Directive {
                name: "Foo".into(),
                args: HashMap::new(),
                children: vec![
                    Node::Directive {
                        name: "Bar".into(),
                        args: HashMap::new(),
                        children: vec![]
                    },
                    Node::Text("baz".into())
                ]
            }
        )
    }

    #[test]
    fn test_parse_comment() {
        assert_eq!(
            parse(
                r#"
@Foo {
    @Comment {
        wee
    }
}
                "#
            ),
            Node::Directive {
                name: "Foo".into(),
                args: HashMap::new(),
                children: vec![Node::Comment("wee".into())]
            }
        )
    }

    #[test]
    fn test_parse() {
        // i'm not hand converting this, just make sure it doesn't panic
        let s = std::fs::read_to_string("../../Sources/PhoenixLiveViewNative/PhoenixLiveViewNative.docc/Tutorials/01 Initial List.tutorial").unwrap();
        parse(&s);
    }

    #[test]
    fn test_depth_first() {
        let root = Node::Directive {
            name: "A".into(),
            args: HashMap::new(),
            children: vec![
                Node::Directive {
                    name: "B".into(),
                    args: HashMap::new(),
                    children: vec![Node::Directive {
                        name: "C".into(),
                        args: HashMap::new(),
                        children: vec![],
                    }],
                },
                Node::Directive {
                    name: "D".into(),
                    args: HashMap::new(),
                    children: vec![],
                },
            ],
        };
        let names = root
            .depth_first()
            .map(|n| match n {
                Node::Directive { ref name, .. } => name,
                _ => panic!(),
            })
            .collect::<Vec<_>>();
        assert_eq!(names, vec!["A", "B", "C", "D"]);
    }
}
