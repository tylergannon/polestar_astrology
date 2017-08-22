class Star < ActiveRecord::Base
  extend FriendlyId
  friendly_id :pinyin, use: :slugged

  has_many :star_palaces
  has_many :comments, as: :commentable
  belongs_to :star_group
  # has_and_belongs_to_many :star_palaces

  def my_comments(member)
    @my_comments ||= comments.where(member_id: member.id)
  end

  def star_palace(palace)
    star_palaces.where(palace_id: palace.id).first
  end

  def full_name
    pinyin + ' : ' + english
  end

  def symbol_name
    pinyin.underscore.gsub(/[\s\-]/, '_')
  end

  def major?
    rank <= 4
  end

  def minor?
    !major?
  end

  def <=> (other)
    [rank, id] <=> [other.rank, other.id]
  end

  def self.reseed
    Star.destroy_all
    id = 0
    STARS.each do |wade_giles, info|
      id += 1
      star = Star.create! id: id, pinyin: info[0], english: info[1], description: info[2], rank: info[3]
    end
  end

  STARS = {
    tzu_wei: ['Zi Wei', 'Emperor', 'The Center, ruler of all, Yang Power', 1],
    tien_fu: ['Tian Fu', 'Empress', 'Primary access to everything, Yin power', 1],
    tien_hsiang: ['Tian Xiang', 'Tutor', 'Power behind throne, access to knowledge', 1],
    tien_chi: ['Tian Ji', 'Oracle', 'Intuition, unusual knowledge', 1],

    tai_yang: ['Tai Yang', 'Sun', 'Prince, possibility to take it all', 2],
    wu_chu: ['Wu Qu', 'General', "The 'old man' and advisor in tactics", 2],
    tai_yin: ['Tai Yin', 'Moon', 'Princess, the link to other realms', 2],
    chu_men: ['Ju Men', 'Great Gate', 'Availability of anything', 2],

    tien_tung: ['Tian Tong', 'Vassal', 'Power from supporting the leader', 3],
    tien_liang: ['Tian Liang', 'Roof Beam', "'Feng Shui', feelings of place", 3],
    wen_chang: ['Wen Chang', 'Magistrate', 'The judge, rule of law', 3],
    wen_chu: ['Wen Qu', 'Priest', 'Access to the divine, rituals', 3],

    lien_chen: ['Lian Zhen', 'Concubine', 'Chastity, close to power if beautiful', 4],
    tan_lang: ['Tan Lang', 'Greedy Wolf', 'Devourer, takes all', 4],
    chi_sha: ['Qi Sha', '7 Killings', 'Death, ruin, bad luck', 4],
    po_chun: ['Po Jun', 'Rebel', 'The one who causes trouble', 4],

    fire_star: ['Huo Xing', 'Fire Star', '', 5],
    ringing_star: ['Ling Xing', 'Water Star', '', 5],
    yang_jen: ['Yang Ren', 'Goat Blade', 'Injuries, but also competition', 5],
    to_lo: ['Tuo Luo', 'Hump Back', '', 5],

    yu_pi: ['You Bi', 'Right Assistant', '', 6],
    tso_fu: ['Zuo Fu', 'Left Assistant', '', 6],
    tien_tsun: ['Tian Cun', 'Storehouse', '', 6],
    tian_yao: ['Tian Yao', 'Beauty', '', 6],

    tien_kuei: ['Tian Kui', 'Leader', '', 7],
    tien_hsi: ['Tian Xi', 'Happiness', '', 7],
    tien_kung: ['Di Gong', 'Void', '', 7],
    tien_yueh: ['Tian Yue', 'Halberd', '', 7],
    tian_hsing: ['Tian Xing', 'Punishment', '', 7],
    ti_chieh: ['Di Jie', 'Loss', '', 7]
  }
  STAR_PINYIN = STARS.values.map(&:first).map{|t| t.titleize.gsub(' ', '').underscore.to_sym}
  def self.find_by_pinyin!(pinyin)
    find_by_pinyin(pinyin)
  end
  def self.find_by_pinyin(pinyin)
    key = pinyin.to_s.gsub(/_/, '-')
    Rails.cache.fetch("star-#{key}") do
      friendly.find(key)
    end
  end

  def self.method_missing(method, *args)
    super unless method.in?(STAR_PINYIN)
    ActiveSupport::Deprecation.warn("Calling Star method named finders is deprecated.  Please use find_by_pinyin.")
    find_by_pinyin method
  end
end
