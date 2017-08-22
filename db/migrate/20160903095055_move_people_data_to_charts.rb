require_relative('20120315063720_create_people')
require_relative('20120315113806_add_chart_id_to_people')
require_relative('20120316071404_add_yin_yang_to_people')
require_relative('20130218080414_add_branches_to_people')

class MovePeopleDataToCharts < ActiveRecord::Migration[5.0]
  ATTRIBUTES = %w(first_name last_name dob yin_yang year_branch_id hour_branch_id member_id)

  def change
    add_column :charts, :first_name, :string
    add_column :charts, :last_name, :string
    add_column :charts, :dob, :datetime
    add_column :charts, :yin_yang, :string
    add_column :charts, :year_branch_id, :integer
    add_column :charts, :hour_branch_id, :integer
    add_column :charts, :member_id, :integer, index: true
    remove_index :charts, :solar_date
    add_index :charts, :solar_date, unique: false


    reversible do |direction|
      direction.up do
        Chart.all.each do |chart|
          chart.people.each_with_index do |person, i|
            attributes = person.attributes.slice(*ATTRIBUTES)
            if i == 0
              print '.'
              chart.slug = nil
              chart.update_attributes! attributes
              chart.reload
              if attributes["first_name"] == "Tyler" && attributes["last_name"] == "Gannon"
                puts chart.inspect
              end
              raise "ARG" unless chart.member_id?
            else
              print '$'
              new_chart = chart.dup
              new_chart.slug = nil
              new_chart.attributes = attributes
              new_chart.save!
              chart.palaces.each do |cp|
                new_chart.palaces.create! cp.attributes.slice('palace_id', 'location_id')
              end
              new_chart.reload
              if attributes["first_name"] == "Tyler" && attributes["last_name"] == "Gannon"
                puts new_chart.inspect
              end
              raise "ARG" unless new_chart.member_id?
            end
          end
        end
      end
    end

    # raise "Can't find" unless Member.find_by_email('tgannon@gmail.com').charts.find_by(first_name: 'Tyler', last_name: 'Gannon')

    revert AddBranchesToPeople
    revert AddYinYangToPeople
    revert AddChartIdToPeople
    revert CreatePeople
  end
end
