require 'spec_helper'

describe CMSScanner::Finders::InterestingFindings::Headers do
  subject(:finder) { described_class.new(target) }
  let(:target)     { CMSScanner::Target.new(url) }
  let(:url)        { 'http://example.com/' }
  let(:fixtures)   { FIXTURES_FINDERS.join('interesting_findings', 'headers') }
  let(:fixture)    { fixtures.join('interesting.txt') }
  let(:headers)    { parse_headers_file(fixture) }

  describe '#passive' do
    before { stub_request(:get, url).to_return(headers: headers) }

    after do
      if @expected
        result = finder.passive

        expect(result).to be_a CMSScanner::Headers
        expect(result).to eql @expected
      end
    end

    context 'when no headers' do
      let(:headers) { {} }

      its(:passive) { should be nil }
    end

    context 'when headers' do
      it 'returns the result' do
        opts      = { confidence: 100, found_by: 'Headers (Passive Detection)' }
        @expected = CMSScanner::Headers.new(url, opts)
      end
    end
  end
end
