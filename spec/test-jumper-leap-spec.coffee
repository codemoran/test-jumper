TestJumper = require '../lib/test-jumper'
TestJumperLeap = require '../lib/test-jumper-leap'
{WorkspaceView} = require 'atom'


# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "TestJumperLeap", ->
  activationPromise = null

  beforeEach =>
    atom.workspaceView = new WorkspaceView
    @leaper = new TestJumperLeap


  it "is able to get the placement target for a bit of code", =>
    spyOn(@leaper, "getCurrentFilePath").andCallFake ->
      'lib/object.js.coffee'

    expect(@leaper.getMovementTarget()[0][0]).toBe('lib/object.js.coffee')


  it "knows if the current file is a spec", =>

    spyOn(@leaper, "getCurrentFilePath").andCallFake ->
      '/object-spec.js.coffee'

    expect(@leaper.currentPathIsSpec()).toBe(true);


  it "knows if the current file is nt a spec", =>

    spyOn(@leaper, "getCurrentFilePath").andCallFake ->
      '/object.js.coffee'

    expect(@leaper.currentPathIsSpec()).toBe(false);


  describe '@_format', ->

    it 'replaces the %s within the string', ->
      replaced_string = TestJumperLeap._format('test-%s-spec','file')
      expect(replaced_string).toBe('test-file-spec')

    it 'replaces the %s at the beginning with a string', ->
      replaced_string = TestJumperLeap._format('%s-spec','file')
      expect(replaced_string).toBe('file-spec')

    it 'replaces the %s at the end with a string', ->
      replaced_string = TestJumperLeap._format('test-%s','file')
      expect(replaced_string).toBe('test-file')

    # legacy support
    it 'without %s in format string, the format is appended', ->
      replaced_string = TestJumperLeap._format('-spec','file')
      expect(replaced_string).toBe('file-spec')


  describe '@_unformat', ->

    it 'works with the %s within the format string', ->
      replaced_string = TestJumperLeap._unformat('test-%s-spec','test-file-spec')
      expect(replaced_string).toBe('file')

    it 'works with the %s within the format string', ->
      replaced_string = TestJumperLeap._unformat('%s-spec','bla-spec')
      expect(replaced_string).toBe('bla')

    it 'works with the %s within the format string', ->
      replaced_string = TestJumperLeap._unformat('test-%s','test-blubb')
      expect(replaced_string).toBe('blubb')

    it 'returns the formatted string, if the format does not match', ->
      replaced_string = TestJumperLeap._unformat('test-%s','blubb-spec')
      expect(replaced_string).toBe('blubb-spec')

    it 'returns the formatted string, if the format does not match in the beginning', ->
      replaced_string = TestJumperLeap._unformat('test-%s-bla','file-xyz-bla')
      expect(replaced_string).toBe('file-xyz-bla')

    it 'returns the formatted string, if the format does not match in the end', ->
      replaced_string = TestJumperLeap._unformat('test-%s-bla','test-spec')
      expect(replaced_string).toBe('test-spec')


    # legacy support
    it 'works without the %s within the format string', ->
      replaced_string = TestJumperLeap._unformat('-spec','foo-spec')
      expect(replaced_string).toBe('foo')


  describe '@_matchFormat', ->

    it 'works with the %s within the format string', ->
      test = TestJumperLeap._matchFormat('test-%s-spec','test-file-spec')
      expect(test).toBe(true)

    it 'works with the %s within the format string', ->
      test = TestJumperLeap._matchFormat('%s-spec','bla-spec')
      expect(test).toBe(true)

    it 'works with the %s within the format string', ->
      test = TestJumperLeap._matchFormat('test-%s','test-blubb')
      expect(test).toBe(true)

    it 'returns false, if the format does not match', ->
      test = TestJumperLeap._matchFormat('test-%s','blubb-spec')
      expect(test).toBe(false)

    it 'returns false, if the format does not match in the beginning', ->
      test = TestJumperLeap._matchFormat('test-%s-bla','file-xyz-bla')
      expect(test).toBe(false)

    it 'returns false, if the format does not match in the end', ->
      test = TestJumperLeap._matchFormat('test-%s-bla','test-spec')
      expect(test).toBe(false)


    # legacy support
    it 'works without the %s within the format string', ->
      test = TestJumperLeap._matchFormat('-spec','foo-spec')
      expect(test).toBe(true)
