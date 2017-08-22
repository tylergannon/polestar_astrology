class Pillar < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: [:finders, :slugged]

  belongs_to :stem
  belongs_to :branch

  def name
    "#{stem.element} #{branch.animal}".titleize
  end

  PILLAR_LOOKUP =[[1, nil, 13, nil, 25, nil, 37, nil, 49, nil],
                  [nil, 2, nil, 14, nil, 26, nil, 38, nil, 50],
                  [51, nil, 3, nil, 15, nil, 27, nil, 39, nil],
                  [nil, 52, nil, 4, nil, 16, nil, 28, nil, 40],
                  [41, nil, 53, nil, 5, nil, 17, nil, 29, nil],
                  [nil, 42, nil, 54, nil, 6, nil, 18, nil, 30],
                  [31, nil, 43, nil, 55, nil, 7, nil, 19, nil],
                  [nil, 32, nil, 44, nil, 56, nil, 8, nil, 20],
                  [21, nil, 33, nil, 45, nil, 57, nil, 9, nil],
                  [nil, 22, nil, 34, nil, 46, nil, 58, nil, 10],
                  [11, nil, 23, nil, 35, nil, 47, nil, 59, nil],
                  [nil, 12, nil, 24, nil, 36, nil, 48, nil, 60]]

  def self.find_by_stem_and_branch(stem, branch)
    find_by_ordinal lookup_pillar(stem, branch)
  end

  def self.lookup_pillar(s, b)
    PILLAR_LOOKUP[b-1][s-1]
  end

  def native_element
    Element.send(branch.native_stem.element)
  end

  def self.find_by_ordinal(i)
    Rails.cache.fetch "pillar-#{i}" do
      includes(:stem, {branch: :native_stem}).find(i)
    end
  end

  def next
    self.class.find_by_ordinal(ordinal % 60 + 1)
  end

  def chinese
    "#{stem.char}#{branch.char}"
  end

  def pinyin
    "#{stem.pinyin} #{branch.pinyin}"
  end

  def cocoa_id
    [stem.id-1, branch.id-1]
  end

  def as_json
    {
      id: cocoa_id,
      name: name,
      chinese: chinese,
      pinyin: pinyin,
      native_element: native_element.name,
      stem: {
        pinyin: stem.pinyin,
        element: stem.element
      },
      branch: {
        pinyin: branch.pinyin,
        animal: branch.animal
      }
    }
  end


  def self.reseed
    Pillar.destroy_all
    stems = Stem.order(:ordinal).ids
    branches = Branch.order(:ordinal).ids
    (1..60).each do |i|
      Pillar.create! id: i, stem_id: stems.first,
          branch_id: branches.first,
          ordinal: i
      stems.rotate!
      branches.rotate!
    end
  end
end
