describe Trainer do
  describe Trainer::TestParser do
    describe "Loading a file" do
      it "raises an error if the file doesn't exist" do
        expect do
          Trainer::TestParser.new("notExistent")
        end.to raise_error(/File not found at path/)
      end

      it "raises an error if FormatVersion is not supported" do
        expect do
          Trainer::TestParser.new("spec/fixtures/InvalidVersionMismatch.plist")
        end.to raise_error("Format version '0.9' is not supported, must be 1.1, 1.2")
      end

      it "loads a file without throwing an error" do
        Trainer::TestParser.new("spec/fixtures/Valid1.plist")
      end
    end

    describe "#auto_convert" do
      it "raises an error if no files were found" do
        expect do
          Trainer::TestParser.auto_convert({ path: "bin" })
        end.to raise_error("No test result files found in directory 'bin', make sure the file name ends with 'TestSummaries.plist' or '.xcresult'")
      end
    end

    describe "#tests_successful?" do
      it "returns false if tests failed" do
        tp = Trainer::TestParser.new("spec/fixtures/Valid1.plist")
        expect(tp.tests_successful?).to eq(false)
      end
    end

    describe "#data" do
      it "parses a single test target's output" do
        tp = Trainer::TestParser.new("spec/fixtures/Valid1.plist")
        expect(tp.data).to eq([
                                {
                                  project_path: "Trainer.xcodeproj",
                                  target_name: "Unit",
                                  test_name: "Unit",
                                  duration: 0.4,
                                  run_destination: {
                                    name: "iPhone SE",
                                    target_architecture: "x86_64",
                                    target_device: {
                                      identifier: "252CADC1-E488-4506-B293-892F59253C63",
                                      name: "iPhone SE",
                                      operating_system_version: "10.0"
                                    }
                                  },
                                  tests: [
                                    {
                                      identifier: "Unit/testExample()",
                                      test_group: "Unit",
                                      name: "testExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "6840EEB8-3D7A-4B2D-9A45-6955DC11D32B",
                                      duration: 0.1
                                    },
                                    {
                                      identifier: "Unit/testExample2()",
                                      test_group: "Unit",
                                      name: "testExample2()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Failure",
                                      guid: "B2EB311E-ED8D-4DAD-8AF0-A455A20855DF",
                                      duration: 0.1,
                                      failures: [
                                        {
                                          file_name: "/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift",
                                          line_number: 19,
                                          message: "XCTAssertTrue failed - ",
                                          performance_failure: false,
                                          failure_message: "XCTAssertTrue failed -  (/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift:19)"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "Unit/testPerformanceExample()",
                                      test_group: "Unit",
                                      name: "testPerformanceExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "72D0B210-939D-4751-966F-986B6CB2660C",
                                      duration: 0.2
                                    }
                                  ],
                                  number_of_tests: 3,
                                  number_of_failures: 1
                                }
                              ])
      end

      it "parses multiple test targets' output without a run destination" do
        tp = Trainer::TestParser.new("spec/fixtures/TestSummaries-NoRunDestination.plist")
        expect(tp.data).to eq([
          {:project_path=>"Foo.xcodeproj",
            :target_name=>"FooTests",
            :test_name=>"FooTests",
            :run_destination=>nil,
            :duration=>0.0,
            :tests=>
            [
              {:identifier=>"BarViewControllerTests/testInit_NoPlaces_NoSelection()",
                :test_group=>"BarViewControllerTests",
                :name=>"testInit_NoPlaces_NoSelection()",
                :object_class=>"IDESchemeActionTestSummary",
                :status=>"Success",
                :guid=>"CA8D1702-A3E7-48FD-8800-5EF827F29D9F",
                :duration=>0.0}],
                :number_of_tests=>1,
                :number_of_failures=>0},
                {:project_path=>"Foo.xcodeproj",
                  :target_name=>"FooViewsTests",
                  :test_name=>"FooViewsTests",
                  :run_destination=>nil,
                  :duration=>0.0,
                  :tests=>
                  [
                    {:identifier=>"FooEmptyTableViewHelperTests/testHeaderViewObservation()",
                      :test_group=>"FooEmptyTableViewHelperTests",
                      :name=>"testHeaderViewObservation()",
                      :object_class=>"IDESchemeActionTestSummary",
                      :status=>"Success",
                      :guid=>"DAFAADD3-8495-4E1E-9869-60701DEC5BE2",
                      :duration=>0.0},
                      {:identifier=>"UIView_ExtensionsTests/testComplexViewIsVisibleInWindow()",
                        :test_group=>"UIView_ExtensionsTests",
                        :name=>"testComplexViewIsVisibleInWindow()",
                        :object_class=>"IDESchemeActionTestSummary",
                        :status=>"Success",
                        :guid=>"D03219FE-B432-4669-B957-42DA8C6FD99E",
                        :duration=>0.0},
                        {:identifier=>"UIView_ExtensionsTests/testSimpleViewIsVisibleInWindow()",
                          :test_group=>"UIView_ExtensionsTests",
                          :name=>"testSimpleViewIsVisibleInWindow()",
                          :object_class=>"IDESchemeActionTestSummary",
                          :status=>"Success",
                          :guid=>"F55CD64D-EC8C-4679-BF41-F5ECAA2CB26F",
                          :duration=>0.0}],
                          :number_of_tests=>3,
                          :number_of_failures=>0},
                          {:project_path=>"Foo.xcodeproj",
                            :target_name=>"FooFoundationTests",
                            :test_name=>"FooFoundationTests",
                            :run_destination=>nil,
                            :duration=>0.0,
                            :tests=>
                            [
                              {:identifier=>
                                "KeyValueObserverDeferredTests/testCancelReleasesObservedObject()",
                                :test_group=>"KeyValueObserverDeferredTests",
                                :name=>"testCancelReleasesObservedObject()",
                                :object_class=>"IDESchemeActionTestSummary",
                                :status=>"Success",
                                :guid=>"913E53E7-BD75-4987-B48E-4D08FB2D441B",
                                :duration=>0.0}],
                                :number_of_tests=>1,
                                :number_of_failures=>0}
                              ])
      end

      it "works as expected with plist" do
        tp = Trainer::TestParser.new("spec/fixtures/Valid1.plist")
        expect(tp.data).to eq([
                                {
                                  project_path: "Trainer.xcodeproj",
                                  target_name: "Unit",
                                  test_name: "Unit",
                                  duration: 0.4,
                                  tests: [
                                    {
                                      identifier: "Unit/testExample()",
                                      test_group: "Unit",
                                      name: "testExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "6840EEB8-3D7A-4B2D-9A45-6955DC11D32B",
                                      duration: 0.1
                                    },
                                    {
                                      identifier: "Unit/testExample2()",
                                      test_group: "Unit",
                                      name: "testExample2()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Failure",
                                      guid: "B2EB311E-ED8D-4DAD-8AF0-A455A20855DF",
                                      duration: 0.1,
                                      failures: [
                                        {
                                          file_name: "/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift",
                                          line_number: 19,
                                          message: "XCTAssertTrue failed - ",
                                          performance_failure: false,
                                          failure_message: "XCTAssertTrue failed -  (/Users/liamnichols/Code/Local/Trainer/Unit/Unit.swift:19)"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "Unit/testPerformanceExample()",
                                      test_group: "Unit",
                                      name: "testPerformanceExample()",
                                      object_class: "IDESchemeActionTestSummary",
                                      status: "Success",
                                      guid: "72D0B210-939D-4751-966F-986B6CB2660C",
                                      duration: 0.2
                                    }
                                  ],
                                  number_of_tests: 3,
                                  number_of_failures: 1
                                }
                              ])
      end

      it "works as expected with xcresult" do
        tp = Trainer::TestParser.new("spec/fixtures/Test.test_result.xcresult")
        expect(tp.data).to eq([
                                {
                                  project_path: "Test.xcodeproj",
                                  target_name: "TestUITests",
                                  test_name: "TestUITests",
                                  duration: 16.05245804786682,
                                  tests: [
                                    {
                                      identifier: "TestUITests.testExample()",
                                      name: "testExample()",
                                      duration: 16.05245804786682,
                                      status: "Success",
                                      test_group: "TestUITests",
                                      guid: ""
                                    }
                                  ],
                                  number_of_tests: 1,
                                  number_of_failures: 0
                                },
                                {
                                  project_path: "Test.xcodeproj",
                                  target_name: "TestThisDude",
                                  test_name: "TestThisDude",
                                  duration: 0.5279300212860107,
                                  tests: [
                                    {
                                      identifier: "TestTests.testExample()",
                                      name: "testExample()",
                                      duration: 0.0005381107330322266,
                                      status: "Success",
                                      test_group: "TestTests",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestTests.testFailureJosh1()",
                                      name: "testFailureJosh1()",
                                      duration: 0.006072044372558594,
                                      status: "Failure",
                                      test_group: "TestTests",
                                      guid: "",
                                      failures: [
                                        {
                                          file_name: "",
                                          line_number: 0,
                                          message: "",
                                          performance_failure: {},
                                          failure_message: "XCTAssertTrue failed (/Users/josh/Projects/fastlane/test-ios/TestTests/TestTests.swift#CharacterRangeLen=0&EndingLineNumber=36&StartingLineNumber=36)"
                                          }
                                      ]
                                    },
                                    {
                                      identifier: "TestTests.testPerformanceExample()",
                                      name: "testPerformanceExample()",
                                      duration: 0.2661939859390259,
                                      status: "Success",
                                      test_group: "TestTests",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestThisDude.testExample()",
                                      name: "testExample()",
                                      duration: 0.0004099607467651367,
                                      status: "Success",
                                      test_group: "TestThisDude",
                                      guid: ""
                                    },
                                    {
                                      identifier: "TestThisDude.testFailureJosh2()",
                                      name: "testFailureJosh2()",
                                      duration: 0.001544952392578125,
                                      status: "Failure",
                                      test_group: "TestThisDude",
                                      guid: "",
                                      failures: [
                                        {
                                          file_name: "",
                                          line_number: 0,
                                          message: "",
                                          performance_failure: {},
                                          failure_message: "XCTAssertTrue failed (/Users/josh/Projects/fastlane/test-ios/TestThisDude/TestThisDude.swift#CharacterRangeLen=0&EndingLineNumber=35&StartingLineNumber=35)"
                                        }
                                      ]
                                    },
                                    {
                                      identifier: "TestThisDude.testPerformanceExample()",
                                      name: "testPerformanceExample()",
                                      duration: 0.2531709671020508,
                                      status: "Success",
                                      test_group: "TestThisDude",
                                      guid: ""
                                    }
                                  ],
                                  number_of_tests: 6,
                                  number_of_failures: 2
                                }
                              ])
      end
    end
  end
end
