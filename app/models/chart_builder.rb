class ChartBuilder
  attr_accessor :chart
  def initialize(chart); self.chart=chart;end

  delegate :year, :month, :day, :hour, :day_of_month, :to => :chart

  def attributes
    {
      ming_id: ming.id,
      inner_element: inner_element,
      zi_wei_id: zi_wei.ordinal,
      tian_fu_id: tian_fu.ordinal,
      tian_xiang_id: tian_xiang.ordinal,
      tian_ji_id: tian_ji.ordinal,
      tai_yang_id: tai_yang.ordinal,
      wu_qu_id: wu_qu.ordinal,
      tai_yin_id: tai_yin.ordinal,
      ju_men_id: ju_men.ordinal,
      tian_tong_id: tian_tong.ordinal,
      tian_liang_id: tian_liang.ordinal,
      wen_chang_id: wen_chang.ordinal,
      wen_qu_id: wen_qu.ordinal,
      lian_zhen_id: lian_zhen.ordinal,
      tan_lang_id: tan_lang.ordinal,
      qi_sha_id: qi_sha.ordinal,
      po_jun_id: po_jun.ordinal,
      huo_xing_id: huo_xing.ordinal,
      ling_xing_id: ling_xing.ordinal,
      yang_ren_id: yang_ren.ordinal,
      tuo_luo_id: tuo_luo.ordinal,
      you_bi_id: you_bi.ordinal,
      zuo_fu_id: zuo_fu.ordinal,
      tian_cun_id: tian_cun.ordinal,
      tian_yao_id: tian_yao.ordinal,
      tian_kui_id: tian_kui.ordinal,
      tian_xi_id: tian_xi.ordinal,
      di_gong_id: di_gong.ordinal,
      tian_yue_id: tian_yue.ordinal,
      tian_xing_id: tian_xing.ordinal,
      di_jie_id: di_jie.ordinal,
      wood_score: elemental_score['wood'],
      fire_score: elemental_score['fire'],
      earth_score: elemental_score['earth'],
      metal_score: elemental_score['metal'],
      water_score: elemental_score['water']
    }
  end

  def ming
    Branch.find_by_ordinal( (12 + month.branch.ordinal - hour.branch.ordinal) % 12 + 1 )
  end

  def inner_element
    INNER_ELEMENT_LOOKUP[(ming.ordinal-1)/2][year.stem.ordinal-1]
  end

  def elemental_score
    score = Hashie::Mash.new ELEMENTS.zip([0]*5).to_h

    [chart.year, chart.month, chart.day, chart.hour].each do |pillar|
      score[pillar.stem.element] += 1
      score[pillar.branch.native_stem.element] += 1
      score[ELEMENT_SCORES_LOOKUP[(pillar.ordinal.to_f/2).round-1]] += 1
    end
    score
  end

  #  Based on Inner Element and Day of Lunar Month

  def zi_wei
    element_index = ELEMENTS.index(inner_element)

    Branch.find_by_pinyin ZI_WEI_LOOKUP[day_of_month-1][element_index]
  end

  #  Based on Zi Wei

  def tian_fu
    Branch.find_by_ordinal((17-zi_wei.ordinal)%12 + 1)
  end

  def tian_ji
    Branch.find_by_ordinal(((zi_wei.ordinal+10)%12)+1)
  end

  def tai_yang
    Branch.find_by_ordinal((zi_wei.ordinal+8)%12+1)
  end

  def wu_qu
    Branch.find_by_ordinal((zi_wei.ordinal+7)%12+1)
  end

  def tian_tong
    Branch.find_by_ordinal((zi_wei.ordinal+6)%12+1)
  end

  def lian_zhen
    Branch.find_by_ordinal((zi_wei.ordinal+3)%12+1)
  end


  #  Based on Tian Fu

  def tian_xiang
    Branch.find_by_ordinal((tian_fu.ordinal+3)%12+1)
  end

  def tai_yin
    Branch.find_by_ordinal((tian_fu.ordinal)%12+1)
  end

  def ju_men
    Branch.find_by_ordinal((tian_fu.ordinal+2)%12+1)
  end

  def tian_liang
    Branch.find_by_ordinal((tian_fu.ordinal+4)%12+1)
  end

  def tan_lang
    Branch.find_by_ordinal((tian_fu.ordinal+1)%12+1)
  end

  def qi_sha
    Branch.find_by_ordinal((tian_fu.ordinal+5)%12+1)
  end

  def po_jun
    Branch.find_by_ordinal((tian_fu.ordinal+9)%12+1)
  end


  # Based on Hour Branch
  def wen_chang
    Branch.find_by_ordinal(12 - ((hour.branch.ordinal) % 12))
  end

  # Based on Hour Stem and Branch
  def wen_qu
    Branch.find_by_ordinal((hour.ordinal+3)%12+1)
  end

  # Based on Branches of Year and Hour
  def huo_xing
    Branch.find_by_pinyin HUO_XING_LOOKUP[hour.branch.ordinal-1][year.branch.ordinal-1]
  end

  # Based on Branches of Year and Hour
  def ling_xing
    Branch.find_by_pinyin LING_XING_LOOKUP[hour.branch.ordinal-1][year.branch.ordinal-1]
  end

  # Based on Stem of Year
  def yang_ren
    Branch.find_by_pinyin(YANG_REN_LOOKUP[year.stem.ordinal-1])
  end

  # Based on Stem of Year
  def tuo_luo
    Branch.find_by_pinyin(TUO_LUO_LOOKUP[year.stem.ordinal-1])
  end

  # Based on Branch of Month
  def you_bi
    Branch.find_by_ordinal((25-month.branch.ordinal)%12+1)
  end

  # Based on Branch of Month
  def zuo_fu
    Branch.find_by_ordinal((month.branch.ordinal + 12 + 1)%12+1)
  end

  # Based on Stem of Year
  def tian_cun
    Branch.find_by_pinyin TIAN_CUN_LOOKUP[year.stem.ordinal-1]
  end

  # Based on Branch of Month
  def tian_yao
    Branch.find_by_ordinal((10+month.branch.ordinal)%12+1)
  end

  # Based on Stem of Year
  def tian_kui
    Branch.find_by_pinyin TIAN_KUI_LOOKUP[year.stem.ordinal-1]
  end

  # Based on Branch of Year
  def tian_xi
    Branch.find_by_pinyin TIAN_XI_LOOKUP[year.branch.ordinal-1]
  end

  # Based on Branch of Hour
  def di_gong
    Branch.find_by_pinyin DI_GONG_LOOKUP[hour.branch.ordinal-1]
  end

  # Based on Stem of Year
  def tian_yue
    Branch.find_by_pinyin TIAN_YUE_LOOKUP[year.stem.ordinal-1]
  end

  # Diametric to the branch of the Month
  def tian_xing
    Branch.find_by_ordinal((6+month.branch.ordinal)%12+1)
  end

  # One behind the Branch of the Hour
  def di_jie
    Branch.find_by_pinyin DI_JIE_LOOKUP[hour.branch.ordinal-1]
  end

  ELEMENTS = %i(wood fire earth metal water).freeze

  INNER_ELEMENT_LOOKUP = [%i(water fire earth wood metal water fire earth wood metal),
                         %i(fire earth wood metal water fire earth wood metal water),
                         %i(wood metal water fire earth wood metal water fire earth),
                         %i(earth wood metal water fire earth wood metal water fire),
                         %i(metal water fire earth wood metal water fire earth wood),
                         %i(fire earth wood metal water fire earth wood metal water)].freeze

   ELEMENT_SCORES_LOOKUP = %i(metal fire wood earth metal fire water earth metal wood
               water earth fire wood water metal fire wood earth metal
               fire water earth metal wood water earth fire wood water ).freeze

  ZI_WEI_LOOKUP = [ %i(chen you wu hai chou),
                    %i(chou wu hai chen yin),
                    %i(yin hai chen chou yin),
                    %i(si chen chou yin mao),
                    %i(yin chou yin zi mao),
                    %i(mao yin wei si chen),
                    %i(wu xu zi yin chen),
                    %i(mao wei si mao si),
                    %i(chen zi yin chou si),
                    %i(wei si mao wu wu),
                    %i(chen yin shen mao wu),
                    %i(si mao chou chen wei),
                    %i(shen hai wu yin wei),
                    %i(si shen mao wei shen),
                    %i(wu chou chen chen shen),
                    %i(you wu you si you),
                    %i(wu mao yin mao you),
                    %i(wei chen wei shen xu),
                    %i(xu zi chen si xu),
                    %i(wei you si wu hai),
                    %i(shen yin xu chen hai),
                    %i(hai wei mao you zi),
                    %i(shen chen shen wu zi),
                    %i(you si si wei chou),
                    %i(zi chou wu si chou),
                    %i(you xu hai xu yin),
                    %i(xu mao chen wei yin),
                    %i(chou shen you shen mao),
                    %i(xu si wu wu mao),
                    %i(hai wu wei hai chen)].freeze

    HUO_XING_LOOKUP = [%i(yin mao chou you yin mao chou you yin mao chou you),
        %i(mao chen yin xu mao chen yin xu mao chen yin xu),
        %i(chen si mao hai chen si mao hai chen si mao hai),
        %i(si wu chen zi si wu chen zi si wu chen zi),
        %i(wu wei si chou wu wei si chou wu wei si chou),
        %i(wei shen wu yin wei shen wu yin wei shen wu yin),
        %i(shen you wei mao shen you wei mao shen you wei mao),
        %i(you xu shen chen you xu shen chen you xu shen chen),
        %i(xu hai you si xu hai you si xu hai you si),
        %i(hai zi xu wu hai zi xu wu hai zi xu wu),
        %i(zi chou hai wei zi chou hai wei zi chou hai wei),
        %i(chou yin zi shen chou yin zi shen chou yin zi shen)].freeze

    LING_XING_LOOKUP = [%i(xu xu mao xu xu xu mao xu xu xu mao xu),
        %i(hai hai chen hai hai hai chen hai hai hai chen hai),
        %i(zi zi si zi zi zi si zi zi zi si zi),
        %i(chou chou wu chou chou chou wu chou chou chou wu chou),
        %i(yin yin wei yin yin yin wei yin yin yin wei yin),
        %i(mao mao shen mao mao mao shen mao mao mao shen mao),
        %i(chen chen you chen chen chen you chen chen chen you chen),
        %i(si si xu si si si xu si si si xu si),
        %i(wu wu hai wu wu wu hai wu wu wu hai wu),
        %i(wei wei zi wei wei wei zi wei wei wei zi wei),
        %i(shen shen chou shen shen shen chou shen shen shen chou shen),
        %i(you you yin you you you yin you you you yin you)].freeze

    ANIMALS         = %i(zi chou yin mao chen si wu wei shen you xu hai).freeze
    DI_JIE_LOOKUP   = ANIMALS.rotate(-1).freeze
    DI_GONG_LOOKUP  = ANIMALS.reverse.freeze
    TIAN_XI_LOOKUP  = ANIMALS.reverse.rotate(2).freeze

    YANG_REN_LOOKUP = %i(mao chen wu wei wu wei you xu zi chou).freeze
    TUO_LUO_LOOKUP  = %i(chou yin chen si chen si wei shen xu hai).freeze
    TIAN_CUN_LOOKUP = %i(yin mao si wu si wu shen you hai zi).freeze
    TIAN_KUI_LOOKUP = %i(chou zi hai you wei shen wei wu si mao).freeze
    TIAN_YUE_LOOKUP = %i(wei shen you hai chou zi chou yin mao si).freeze
end
