
#= require util/gateway

describe 'Gateway class', ->

  beforeEach ->
    @subject = new window.meldd.Gateway()
    @name = 'foo'
    @value = $('body')

  afterEach ->
    @subject = undefined

  describe 'has a "register" method that', ->

    it 'claims to take no parameters', ->
      expect(@subject).to.be.an 'object'
      expect(@subject.register).to.have.length 0

    describe 'when called with', ->

      it 'no parameters, neither fails nor does anything of use', ->
        # NOTE: What's the difference between `expect(x).to.be y` and
        # `expect(x).to == y`? The first compares object *identity*, the second
        # compares object *values*.
        expect(@subject.register()).to.be undefined
        expect(Object.keys(@subject.items)).to == ['null']
        expect(@subject.items[null]).to.be undefined

      it 'one parameter, neither fails or has any effect', ->
        expect(@subject.use 'foo').to.be undefined        # nothing here
        expect(@subject.register 'foo').to.be undefined   # nothing was here
        expect(@subject.use 'foo').to.be undefined        # still nothing here

      it 'key and data values, stores the data using the key', ->
        expect(@subject.items).to.be.empty()
        @subject.register 'foo', 'bar'
        expect(@subject.items['foo']).to.be 'bar'
        expect(Object.keys(@subject.items).length).to.be 1

      describe 'key/data values and', ->

        # NOTE: We need the group to know what items are in it. Do we need an
        # item to know what groups it's in? Can't think of any reason now...

        describe 'one group name', ->

          beforeEach ->
            @subject.register 'foo', 'bar', 'group1'

          it 'stores the data using the key', ->
            expect(@subject.items['foo']).to.be 'bar'

          it 'adds the key to the group', ->
            expect(@subject.groups['group1']).to == ['foo']

        describe 'two group names', ->

          beforeEach ->
            @subject.register 'foo', 'bar', 'group1', 'another group'

          it 'stores the data using the key, once', ->
            expect(@subject.items['foo']).to.be 'bar'
            expect(Object.keys(@subject.items)).to.have.length 1

          it 'adds the key to both groups', ->
            expect(@subject.groups['another group']).to == ['foo']

  describe 'has a "use" method that', ->

    beforeEach ->
      @subject.register @name, @value

    it 'takes one parameter', ->
      expect(@subject.use).to.have.length 1

    describe 'when called using a key previously used by "register"', ->

      it 'returns the same value passed to "register"', ->
        expect(@subject.use @name).to.be @value

  describe 'has a "useGroup" method that', ->

    it 'takes one parameter', ->
      expect(@subject.useGroup).to.have.length 1

    describe 'when called using', ->

      it 'a nonexistent group name, returns an empty object', ->
        group = @subject.useGroup 'not found'
        expect(group).to.be.an 'object'
        expect(group).to.be.empty()

      describe 'a group with one item, returns an', ->

        beforeEach ->
          @subject.register 'foo', 'bar', 'group1'
          @group = @subject.useGroup 'group1'

        it 'Array of length 1', ->
          expect(@group).to.be.an(Array).and.have.length 1

        it 'with the correct single item value as the only group item', ->
          expect(@group[0]).to.be 'bar'

      describe 'two groups with one identical item, returns', ->

        beforeEach ->
          @subject.register 'this', @, 'group1', 'group2'
          @group1 = @subject.useGroup 'group1'
          @group2 = @subject.useGroup 'group2'

        it 'the identical item in both groups', ->
          expect(@group1).to.have.length 1
          expect(@group2).to.have.length 1
          # Changing the condition below to `.not.to.be` causes Teaspoon/Mocha
          # to fail with an error message, "Converting circular structure to
          # JSON". Leaving it as is produces no such error. WtF?
          expect(@group1[0]).to.be @group2[0]
