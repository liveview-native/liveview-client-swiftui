import XCTest
import SwiftSoup

@testable import PhoenixLiveViewNative

final class DOMTests: XCTestCase {
    func testParsing()throws {
        var result: Elements = try DOM.parse("<div>Foo</div>")

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(try result[0].text(), "Foo")
        XCTAssertEqual(result[0].tagName(), "div")
        
        result = try DOM.parse("<div>Bar</div><Text>Biz</Text>")
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(try result[0].text(), "Bar")
        XCTAssertEqual(result[0].tagName(), "div")
        XCTAssertEqual(try result[1].text(), "Biz")
        XCTAssertEqual(result[1].tagName(), "text")
    }
    
    func testAll()throws {
        let sampleHtml = """
        <div class="foo">Foo 1</div>
        <div class="bar">Bar 1</div>
        <div class="foo">Foo 2</div>
        """
        
        let htmlTree = try DOM.parse(sampleHtml)
        
        let result = try DOM.all(htmlTree, ".foo")
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(try result[0].text(), "Foo 1")
    }
    
    func testMaybeOne()throws {
        var sample = """
        <div class="foo">Foo 1</div>
        <div class="bar">Bar 1</div>
        <div class="foo">Foo 2</div>
        """
        
        var htmlTree = try DOM.parse(sample)
        
        var (result, element, _): (String, Element?, String) = try DOM.maybeOne(htmlTree, ".bar")
        
        XCTAssertEqual(result, "ok")
        XCTAssertEqual(try element!.text(), "Bar 1")
        
        (result, element, _) = try DOM.maybeOne(htmlTree, ".foo")
        XCTAssertEqual(result, "error")
        XCTAssertEqual(element, nil)

        (result, element, _) = try DOM.maybeOne(htmlTree, ".biz")
        XCTAssertEqual(result, "error")
        XCTAssertEqual(element, nil)

        sample = """
        "<div data-phx-main=\"true\" data-phx-session=\"SFMyNTY.g2gDaAJhBHQAAAAHZAACaWRtAAAAFHBoeC1GbS1icW1JZ1hIZ0NmNFFDZAAKcGFyZW50X3BpZGQAA25pbGQACHJvb3RfcGlkZAADbmlsZAAJcm9vdF92aWV3ZAAtRWxpeGlyLlBob2VuaXguTGl2ZVZpZXdUZXN0LldpdGhDb21wb25lbnRMaXZlZAAGcm91dGVyZAAiRWxpeGlyLlBob2VuaXguTGl2ZVZpZXdUZXN0LlJvdXRlcmQAB3Nlc3Npb250AAAAAGQABHZpZXdkAC1FbGl4aXIuUGhvZW5peC5MaXZlVmlld1Rlc3QuV2l0aENvbXBvbmVudExpdmVuBgDO0MBpeAFiAAFRgA.lWdk-lH-6vNUKyDdsUDYYQE5j6Mtuuc1cC16am1k3Ak\" data-phx-static=\"SFMyNTY.g2gDaAJhBHQAAAADZAAKYXNzaWduX25ld2pkAAVmbGFzaHQAAAAAZAACaWRtAAAAFHBoeC1GbS1icW1JZ1hIZ0NmNFFDbgYAztDAaXgBYgABUYA.EqK2S1Hpxe298NfuVbTBjBzSACIzmlRK1x0CHWjRDQs\" data-phx-view=\"LiveViewTest.WithComponentLive\" id=\"phx-Fm-bqmIgXHgCf4QC\">Redirect: none\n\n <div data-phx-component=\"1\" id=\"chris\" phx-target=\"#chris\" phx-click=\"transform\">\n chris says hi\n \n</div>
          <div data-phx-component=\"2\" id=\"jose\" phx-target=\"#jose\" phx-click=\"transform\">\n jose says hi\n \n</div>
        </div>"
        """
        
        htmlTree = try DOM.parse(sample)
        (result, element, _) = try DOM.maybeOne(htmlTree, "#chris", "phx-target")
        
        XCTAssertEqual(try element!.attr("id"), "chris")
    }
    
    func testAllAttributes()throws {
        let sample = """
        <div data-foo="abc"></div>
        <div data-bar="def">
            <div data-foo="ghi"></div>
        </div>
        <div data-foo="jkl"></div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        let result: Array<String> = try DOM.allAttributes(htmlTree, "data-foo")
        
        XCTAssertEqual(result, ["abc", "ghi", "jkl"])
    }
    
    func testAllValues()throws {
        let sample = "<div foo=\"foo\" bar=\"bar\" phx-value-baz=\"baz\" value=\"123\"></div>"
        
        let htmlTree = try DOM.parse(sample)
        
        let actual = try DOM.allValues(htmlTree[0])
        
        XCTAssertEqual(["baz": "baz", "value": "123"], actual)
    }
    
    func testInspectHTML()throws {
        let sample = "<div class=\"foo\">\n  Foo\n  <div class=\"baz\">Baz</div>\n</div>\n<div class=\"bar\">\n  Bar\n</div>"
        
        // many of elements
        let htmlTree = try DOM.parse(sample)
        
        var result: String = try DOM.inspectHTML(htmlTree)
        var expected = "    <div class=\"foo\">\n     Foo\n     <div class=\"baz\">Baz</div>\n   </div>\n    <div class=\"bar\">\n     Bar\n   </div>\n"
        XCTAssertEqual(result, expected)
        
        // single element
        let firstElement: Element = htmlTree[0]

        result = try DOM.inspectHTML(firstElement)
        expected = "    <div class=\"foo\">\n     Foo\n     <div class=\"baz\">Baz</div>\n   </div>\n"

        XCTAssertEqual(result, expected)

        // elements form a select

        let all = try DOM.all(htmlTree, "div")

        result = try DOM.inspectHTML(all)
        expected = "    <div class=\"foo\">\n     Foo\n     <div class=\"baz\">Baz</div>\n   </div>\n    <div class=\"baz\">Baz</div>\n    <div class=\"bar\">\n     Bar\n   </div>\n"

        XCTAssertEqual(result, expected)
    }
        
    func testTag()throws {
        let sample = """
        <div class="foo">Foo</div>
        <text class="bar">Bar</text>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        XCTAssertEqual(DOM.tag(htmlTree[0]), "div")
        XCTAssertEqual(DOM.tag(htmlTree[1]), "text")
    }
    
    func testAttribute()throws {
        let sample = """
        <div data-phx-session="123456" data-phx-main="true"></div>
        """
        
        let htmlTree = try DOM.parse(sample)
        let element = htmlTree[0]
        
        XCTAssertEqual(try DOM.attribute(element, "data-phx-session"), "123456")
        XCTAssertEqual(try DOM.attribute(element, "data-phx-main"), "true")
        
        // if a string representation of the element is used
        XCTAssertEqual(try DOM.attribute(sample, "data-phx-session"), nil)
    }
    
    func testToHTML()throws {
        var sample = "<div><div class=\"foo\">Foo</div>\n\n<div class=\"bar\">Bar</div></div>"
        
        var htmlTree = try DOM.parse(sample)
        
        var result: String = try DOM.toHTML(htmlTree)
        
        XCTAssertEqual(result, sample)
        
        sample = "<div class=\"foo\">Foo\n\n</div>"
        
        htmlTree = try DOM.parse(sample)
        
        result = try DOM.toHTML(htmlTree[0])
        
        XCTAssertEqual(result, sample)
    }

    func testToText()throws {
        let sample = """
        <div class="foo">Foo
            <div class="biz">Biz</div>
        </div>
        <div class="bar">Bar</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        let result: String = try DOM.toText(htmlTree)
        
        XCTAssertEqual(result, "Foo Biz Bar")
    }
    
    func testByID() throws {
        let sample = """
        <div class="foo" id="foo">Foo
            <div class="biz" id="biz">Biz</div>
        </div>
        <div class="foo" id="foo">Foo</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        var result: Element = try DOM.byID(htmlTree, "biz")
        
        XCTAssertEqual(try result.text(), "Biz")
        
        do {
            result = try DOM.byID(htmlTree, "foo")
            XCTFail("Should have thrown error")
        } catch {
            XCTAssert(true, "finding multiple elements by ID correctly throws error")
        }

        do {
            result = try DOM.byID(htmlTree, "bar")
            XCTFail("Should have thrown error")
        } catch {
            XCTAssert(true, "finding multiple elements by ID correctly throws error")
        }
    }
    
    func testChildNodes()throws {
        let sample = """
        <div class="foo">Foo
            <div class="biz">Biz</div>
            <div class="fizz">Fizz</div>
        </div>
        <div class="bar">Bar</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        var element = htmlTree[0]
        var children = DOM.childNodes(element)
        
        XCTAssertEqual(try children[0].text(), "Biz")
        XCTAssertEqual(try children[1].text(), "Fizz")
        
        element = htmlTree[1]
        children = DOM.childNodes(element)
        
        XCTAssertEqual(children.count, 0)
        
        // if a string representation of the elements
        children = DOM.childNodes(sample)
        XCTAssertEqual(children.count, 0)
    }
    
    func testAttrs()throws {
        let sample = """
        <div class="foo" data-phx-session="asdf">Foo</div>
        <div>Bar</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        var element = htmlTree[0]
        var attributes = DOM.attrs(element)

        XCTAssertEqual(attributes.size(), 2)
        XCTAssertEqual(attributes.get(key: "class"), "foo")
        XCTAssertEqual(attributes.get(key: "data-phx-session"), "asdf")
        
        element = htmlTree[1]
        attributes = DOM.attrs(element)
        
        XCTAssertEqual(attributes.size(), 0)
    }
    
    func testInnerHTML()throws {
        let sample = """
        <div class="foo" id="foo">Foo
            <div class="biz">Biz</div>
            <div class="fizz">Fizz</div>
        </div>
        <div class="bar">Bar</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        let result = try DOM.innerHTML(htmlTree, "foo")
        
        XCTAssertEqual(try result[0].text(), "Biz")
        XCTAssertEqual(try result[1].text(), "Fizz")
        
    }
    
    func testComponentID()throws {
        let sample = """
        <div data-phx-component="123"></div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        let result = try DOM.componentID(htmlTree[0])
        
        XCTAssertEqual(result, "123")
    }
    
    func testFindStaticViews()throws {
        let sample = """
        <div id="foo" data-phx-static="abc">Foo
            <div id="biz" data-phx-static="def">Biz</div>
            <div id="fizz">Fizz</div>
        </div>
        <div id="bar" data-phx-static="ghi">Bar</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        let results = try DOM.findStaticViews(htmlTree)
        
        XCTAssertEqual(results["foo"], "abc")
        XCTAssertEqual(results["biz"], "def")
        XCTAssertEqual(results["bar"], "ghi")
        XCTAssertNil(results["fizz"])
    }
    
    func testFindLiveViews()throws {
        let tooBigSession: String = [String](repeating: "t", count: 4432).joined()
        
        var sample = """
               <h1>top</h1>
               <div data-phx-view="789"
                 data-phx-session="SESSION1"
                 id="phx-123"></div>
               <div data-phx-parent-id="456"
                   data-phx-view="789"
                   data-phx-session="SESSION2"
                   data-phx-static="STATIC2"
                   id="phx-456"></div>
               <div data-phx-session="\(tooBigSession)"
                 data-phx-view="789"
                 id="phx-458"></div>
               <h1>bottom</h1>
               """
        
        var htmlTree = try DOM.parse(sample)
        var results = try DOM.findLiveViews(htmlTree)
        
        XCTAssert(results[0] == ("phx-123", "SESSION1", nil))
        XCTAssert(results[1] == ("phx-456", "SESSION2", "STATIC2"))
        XCTAssert(results[2] == ("phx-458", tooBigSession, nil))
        
        sample = """
        <div id="foo" data-phx-static="abc">Foo
            <div id="biz" data-phx-static="def">Biz</div>
            <div id="fizz">Fizz</div>
        </div>
        <div id="bar" data-phx-static="ghi">Bar</div>
        """
        
        htmlTree = try DOM.parse(sample)
        results = try DOM.findLiveViews(htmlTree)
        
        XCTAssertEqual(results.count, 0)
        
        sample = """
               <h1>top</h1>
               <div data-phx-view="789"
                 data-phx-session="SESSION1"
                 id="phx-123"></div>
               <div data-phx-parent-id="456"
                   data-phx-view="789"
                   data-phx-session="SESSION2"
                   data-phx-static="STATIC2"
                   id="phx-456"></div>
               <div data-phx-session="SESSIONMAIN"
                 data-phx-view="789"
                 data-phx-main="true"
                 id="phx-458"></div>
               <h1>bottom</h1>
               """
        
        htmlTree = try DOM.parse(sample)
        results = try DOM.findLiveViews(htmlTree)
        
        XCTAssert(results[0] == ("phx-458", "SESSIONMAIN", nil))
        XCTAssert(results[1] == ("phx-123", "SESSION1", nil))
        XCTAssert(results[2] == ("phx-456", "SESSION2", "STATIC2"))

    }
    
    func testDeepMerge()throws {
        let target: Payload = [
            "0": "foo",
            "1": "",
            "3": [
                "1": [
                    "0": "bar"
                ],
                "2": [
                    "0": "biz"
                ]
              ]
            ]

        let source: Payload = [
            "1": "oof",
            "2": "rab",
            "3": [
                "1": [
                    "0": "fib"
                ],
                "2": "bif"
              ],
            "4": [
                "0": "zib"
              ]
            ]

        let expected: Payload = [
            "0": "foo",
            "1": "oof",
            "2": "rab",
            "3": [
                "1": [
                    "0": "fib"
                    ],
                "2": "bif"
                ],
            "4": [
                "0": "zib"
            ]
        ]
        
        let result = try DOM.deepMerge(target, source)
        
        compareNestedDictionaries(expected, result)
    }
    
    func testFilter()throws {
        let sample = """
        <div data-phx="123">Foo
            <div data-phx="456">Bar</div>
            <div>Baz</div>
        </div>
        <div>Baz</div>
        <div data-phx="789">Biz</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        // Elements
        
        var result = DOM.filter(htmlTree) { element in
            do {
                return try DOM.attribute(element, "data-phx") != nil
            } catch {
                return false
            }
        }
        
        XCTAssertEqual(result[0].ownText(), "Foo")
        XCTAssertEqual(result[1].ownText(), "Bar")
        XCTAssertEqual(result[2].ownText(), "Biz")
        XCTAssertEqual(result.count, 3)
        
        // Element
        
        result = DOM.filter(htmlTree[0]) { element in
            do {
                return try DOM.attribute(element, "data-phx") != nil
            } catch {
                return false
            }
        }
        
        XCTAssertEqual(result[0].ownText(), "Foo")
        XCTAssertEqual(result[1].ownText(), "Bar")
        XCTAssertEqual(result.count, 2)
    }
    
    func testReverseFilter()throws {
        let sample = """
        <div data-phx="123">Foo
            <div data-phx="456">Bar</div>
            <div>Baz</div>
        </div>
        <div>Baz</div>
        <div data-phx="789">Biz</div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        // Elements
        
        var result = DOM.reverseFilter(htmlTree) { element in
            do {
                return try DOM.attribute(element, "data-phx") != nil
            } catch {
                return false
            }
        }

        XCTAssertEqual(result[0].ownText(), "Biz")
        XCTAssertEqual(result[1].ownText(), "Bar")
        XCTAssertEqual(result[2].ownText(), "Foo")
        XCTAssertEqual(result.count, 3)
        
        // Element
        
        result = DOM.reverseFilter(htmlTree[0]) { element in
            do {
                return try DOM.attribute(element, "data-phx") != nil
            } catch {
                return false
            }
        }

        XCTAssertEqual(result[0].ownText(), "Bar")
        XCTAssertEqual(result[1].ownText(), "Foo")
        XCTAssertEqual(result.count, 2)
    }
    
    func testMergeDiff()throws {
        let rendered: Payload = [
            "0": "http://www.example.com/flash-root",
            "1": "",
            "2": "",
            "3": 1,
            "4": "<div></div>",
            "5": [
                "0": "",
                "1": "",
                "2": "",
                "s": ["<div id=\"", "\">\nstateless_component[",
               "]:info\nstateless_component[", "]:error\n</div>\n"]
            ],
            "c": [
                "1": [
                    "0": "flash-component",
                    "1": "1",
                    "2": "ok!",
                    "3": "",
                    "s": ["<div id=\"", "\" phx-target=\"",
                 "\" phx-click=\"click\">\n<span phx-click=\"lv:clear-flash\">Clear all</span>\n<span phx-click=\"lv:clear-flash\" phx-value-key=\"info\">component[",
                 "]:info</span>\n<span phx-click=\"lv:clear-flash\" phx-value-key=\"error\">component[",
                 "]:error</span>\n</div>\n"]
              ]
            ],
            "s": ["uri[", "]\nroot[", "]:info\nroot[", "]:error\n", "\nchild[", "]\n","\n"]
          ]
        
        let diff: Payload = ["c": ["1": ["2": "ok!", "3": "oops!"]]]
        
        let result = try DOM.mergeDiff(rendered, diff)
        
        let expected: Payload = [
            "0": "http://www.example.com/flash-root",
            "1": "",
            "2": "",
            "3": 1,
            "4": "<div></div>",
            "5": [
                "0": "",
                "1": "",
                "2": "",
                "s": ["<div id=\"", "\">\nstateless_component[",
               "]:info\nstateless_component[", "]:error\n</div>\n"]
            ],
            "c": [
                "1": [
                    "0": "flash-component",
                    "1": "1",
                    "2": "ok!",
                    "3": "oops!",
                    "s": ["<div id=\"", "\" phx-target=\"",
                 "\" phx-click=\"click\">\n<span phx-click=\"lv:clear-flash\">Clear all</span>\n<span phx-click=\"lv:clear-flash\" phx-value-key=\"info\">component[",
                 "]:info</span>\n<span phx-click=\"lv:clear-flash\" phx-value-key=\"error\">component[",
                 "]:error</span>\n</div>\n"]
              ]
            ],
            "s": ["uri[", "]\nroot[", "]:info\nroot[", "]:error\n", "\nchild[", "]\n","\n"]
          ]
        
        compareNestedDictionaries(expected, result)
    }
        
    func testDropCids()throws {
        let rendered: Payload = [
            "c": [
                "1": ["0": "foo"],
                "2": ["0": "bar"],
                "3": ["0": "baz"]
            ],
        ]
        
        let cids: Array<Int> = [1,3]
        
        let result = DOM.dropCids(rendered, cids)
        
        let expected: Payload = [
            "c": [
                "2": ["0": "bar"]
            ],
        ]
        
        compareNestedDictionaries(expected, result)
    }
    
    func testComponentIDs()throws {
        let sample = """
        <div data-phx-main="true" data-phx-session="SFMyNTY.g2gDaAJhBHQAAAAHZAACaWRtAAAAFHBoeC1GbkR3TXhTR1BHQTlid1JQZAAKcGFyZW50X3BpZGQAA25pbGQACHJvb3RfcGlkZAADbmlsZAAJcm9vdF92aWV3ZAAlRWxpeGlyLlBob2VuaXguTGl2ZVZpZXdUZXN0LkZsYXNoTGl2ZWQABnJvdXRlcmQAIkVsaXhpci5QaG9lbml4LkxpdmVWaWV3VGVzdC5Sb3V0ZXJkAAdzZXNzaW9udAAAAABkAAR2aWV3ZAAlRWxpeGlyLlBob2VuaXguTGl2ZVZpZXdUZXN0LkZsYXNoTGl2ZW4GABQHEoB4AWIAAVGA.BDGnjwPAeKzS5jNf5GtWoYx2nRMYWt_Lv_rglRhSUjQ" data-phx-static="SFMyNTY.g2gDaAJhBHQAAAADZAAKYXNzaWduX25ld2pkAAVmbGFzaHQAAAAAZAACaWRtAAAAFHBoeC1GbkR3TXhTR1BHQTlid1JQbgYAFAcSgHgBYgABUYA.V7O5lgauyk9vb1ZQbPieh3jpCjZ1CRG05dZAR-ldWKg" data-phx-view="LiveViewTest.FlashLive" id="phx-FnDwMxSGPGA9bwRP">uri[http://www.example.com/flash-root]
        root[]:info
        root[]:error
        <div data-phx-component="1" id="flash-component" phx-target="1" phx-click="click"><span phx-click="lv:clear-flash">Clear all</span><span phx-click="lv:clear-flash" phx-value-key="info">component[]:info</span><span phx-click="lv:clear-flash" phx-value-key="error">component[]:error</span></div>
        child[<div data-phx-parent-id="phx-FnDwMxSGPGA9bwRP" data-phx-session="SFMyNTY.g2gDaAJhBHQAAAAHZAACaWRtAAAAC2ZsYXNoLWNoaWxkZAAKcGFyZW50X3BpZFhkAA1ub25vZGVAbm9ob3N0AAAB1gAAAAAAAAAAZAAIcm9vdF9waWRYZAANbm9ub2RlQG5vaG9zdAAAAdYAAAAAAAAAAGQACXJvb3Rfdmlld2QAJUVsaXhpci5QaG9lbml4LkxpdmVWaWV3VGVzdC5GbGFzaExpdmVkAAZyb3V0ZXJkACJFbGl4aXIuUGhvZW5peC5MaXZlVmlld1Rlc3QuUm91dGVyZAAHc2Vzc2lvbnQAAAAAZAAEdmlld2QAKkVsaXhpci5QaG9lbml4LkxpdmVWaWV3VGVzdC5GbGFzaENoaWxkTGl2ZW4GACMHEoB4AWIAAVGA.DEzDbUo6P7cBPByCHO5mo2wK-bxa2Ru_GX6_5ZUGkug" data-phx-static="" data-phx-view="LiveViewTest.FlashChildLive" id="flash-child"></div>]
        <div id="">
        stateless_component[]:info
        stateless_component[]:error
        </div></div>
        """
        
        let htmlTree = try DOM.parse(sample)
        
        let result = try DOM.componentIDs("phx-FnDwMxSGPGA9bwRP", htmlTree)
        
        let expected: Array<Int> = [1]
        
        XCTAssertEqual(expected, result)
    }
    
    func testRenderDiff()throws {
        var sample: Payload = [
            "0": "",
            "1": [
              "d": [["foo1.jpeg", "0", "nil", ""], ["foo2.jpeg", "0", "nil", ""]],
              "s": ["\n    lv:", ":", "%\n    channel:", "\n    ", "\n  "]
            ],
            "2": "<input data-phx-active-refs=\"1282,1346\" data-phx-done-refs=\"\" data-phx-preflighted-refs=\"\" data-phx-update=\"ignore\" data-phx-upload-ref=\"phx-FnLSu0zdGSgfdQhC\" id=\"phx-FnLSu0zdGSgfdQhC\" name=\"avatar\" phx-hook=\"Phoenix.LiveFileUpload\" type=\"file\" multiple></input>",
            "s": ["", "\n<form phx-change=\"validate\" phx-submit=\"save\">\n  ", "\n  ",
             "\n  <button type=\"submit\">save</button>\n</form>\n"]
          ]
        
        var actual: Elements = try DOM.renderDiff(sample)
        
        var expected = "<form phx-change=\"validate\" phx-submit=\"save\">\n  \n    lv:foo1.jpeg:0%\n    channel:nil\n    \n  \n    lv:foo2.jpeg:0%\n    channel:nil\n    \n  \n  <input data-phx-active-refs=\"1282,1346\" data-phx-done-refs=\"\" data-phx-preflighted-refs=\"\" data-phx-update=\"ignore\" data-phx-upload-ref=\"phx-FnLSu0zdGSgfdQhC\" id=\"phx-FnLSu0zdGSgfdQhC\" name=\"avatar\" phx-hook=\"Phoenix.LiveFileUpload\" type=\"file\" multiple>\n  <button type=\"submit\">save</button>\n</form>"
                
        XCTAssertEqual(expected, try DOM.toHTML(actual))
        
        sample = [
            "0": ["d": [[1], [2]], "s": ["\n    ", "\n  "]],
            "c": [
                "1": [
                    "0": "",
                    "1": "upload0",
                    "2": "1",
                    "3": "",
                    "4": "<input data-phx-active-refs=\"\" data-phx-done-refs=\"\" data-phx-preflighted-refs=\"\" data-phx-update=\"ignore\" data-phx-upload-ref=\"phx-FnL7qteVzAAQNwdH\" id=\"phx-FnL7qteVzAAQNwdH\" name=\"avatar\" phx-hook=\"Phoenix.LiveFileUpload\" type=\"file\" multiple></input>",
                    "s": ["", "\n<form phx-change=\"validate\" id=\"",
                          "\" phx-submit=\"save\" phx-target=\"", "\">\n  ", "\n  ",
                          "\n  <button type=\"submit\">save</button>\n</form>\n"]
                    ],
                "2": ["s": ["loading...\n"]]
            ],
            "s": ["<div>\n  ", "\n</div>\n"]
        ]
        
        actual = try DOM.renderDiff(sample)

        expected = "<div>\n  \n    <form phx-change=\"validate\" id=\"upload0\" phx-submit=\"save\" phx-target=\"1\" data-phx-component=\"1\">\n  \n  <input data-phx-active-refs=\"\" data-phx-done-refs=\"\" data-phx-preflighted-refs=\"\" data-phx-update=\"ignore\" data-phx-upload-ref=\"phx-FnL7qteVzAAQNwdH\" id=\"phx-FnL7qteVzAAQNwdH\" name=\"avatar\" phx-hook=\"Phoenix.LiveFileUpload\" type=\"file\" multiple>\n  <button type=\"submit\">save</button>\n</form>\n  \n    loading...\n\n  \n</div>"

        XCTAssertEqual(expected, try DOM.toHTML(actual))
    }

    static var allTests = [
        ("testParsing", testParsing),
        ("testAll", testAll),
        ("testMaybeOne", testMaybeOne),
        ("testAllAttributes", testAllAttributes),
        ("testInspectHTML", testInspectHTML),
        ("testTagName", testTag),
        ("testAttribute", testAttribute),
        ("testToHTML", testToHTML),
        ("testToText", testToText),
        ("testByID", testByID),
        ("testChildNodes", testChildNodes),
        ("testAttrs", testAttrs),
        ("testInnerHTML", testInnerHTML),
        ("testComponentID", testComponentID),
        ("testfindStaticViews", testFindStaticViews),
        ("testFindLiveViews", testFindLiveViews),
        ("testDeepMerge", testDeepMerge),
        ("testFilter", testFilter),
        ("testReverseFilter", testReverseFilter),
        ("testDropCids", testDropCids)
    ]
    
    private func compareNestedDictionaries(_ expected: Payload, _ actual: Payload) -> Void {
        if expected.count != actual.count {
            XCTFail("The two objects are not equal")
            return
        }
        
        for (key, value) in expected {
            let expectedValue = value
            let actualValue = actual[key]

            // This is terrible but it works and it only exists in the tests soooo... ¯\_(ツ)_/¯
            if let expectedDict = expectedValue as? Payload, let actualDict = actualValue as? Payload {
                compareNestedDictionaries(expectedDict, actualDict)
                continue
            } else if let expectedStringArray = expectedValue as? Array<String>, let actualStringArray = actualValue as? Array<String> {
                XCTAssertEqual(expectedStringArray, actualStringArray)
            } else if let expectedIntArray = expectedValue as? Array<Int>, let actualIntArray = actualValue as? Array<Int> {
                XCTAssertEqual(expectedIntArray, actualIntArray)
            } else if let expectedString = expectedValue as? String, let actualString = actualValue as? String {
                XCTAssertEqual(expectedString, actualString)
            } else if let expectedInt = expectedValue as? Int, let actualInt = actualValue as? Int {
                XCTAssertEqual(expectedInt, actualInt)
            } else {
                XCTFail()
            }
        }
    }
}
