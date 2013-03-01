class Birdie
@@birds = [    {
    :abbr => :anapla,
    :name => "Sorsa"
    },
    {
    :abbr => :anacre,
    :name => "Sorsa"
    },
    {
    :abbr => :anaacu,
    :name => "Sorsa"
    },
    {
    :abbr => :anacly,
    :name => "Sorsa"
    },
    {
    :abbr => :aytfer,
    :name => "Sorsa"
    },
    {
    :abbr => :buccla,
    :name => "Sorsa"
    },
    {
    :abbr => :mermer,
    :name => "Sorsa"
    },
    {
    :abbr => :fulatr,
    :name => "Sorsa"
    },
    {
    :abbr => :gavarc,
    :name => "Sorsa"
    },
    {
    :abbr => :podcri,
    :name => "Sorsa"
    },
    {
    :abbr => :podgri,
    :name => "Sorsa"
    },
    {
    :abbr => :podaur,
    :name => "Sorsa"
    },
    {
    :abbr => :cygcyg,
    :name => "Sorsa"
    },
    {
    :abbr => :ansfab,
    :name => "Sorsa"
    },
    {
    :abbr => :bracan,
    :name => "Sorsa"
    },
    {
    :abbr => :anapen,
    :name => "Sorsa"
    },
    {
    :abbr => :anaque,
    :name => "Sorsa"
    },
    {
    :abbr => :aytful,
    :name => "Sorsa"
    },
    {
    :abbr => :melfus,
    :name => "Sorsa"
    },
    {
    :abbr => :merser,
    :name => "Sorsa"
    },
    {
    :abbr => :meralb,
    :name => "Sorsa"
    },
    {
    :abbr => :larmin,
    :name => "Sorsa"
    },
    {
    :abbr => :larrid,
    :name => "Sorsa"
    },
    {
    :abbr => :larcan,
    :name => "Sorsa"
    },
    {
    :abbr => :stehir,
    :name => "Sorsa"
    },
    {
    :abbr => :galgal,
    :name => "Sorsa"
    },
    {
    :abbr => :trigla,
    :name => "Sorsa"
    },
    {
    :abbr => :trineb,
    :name => "Sorsa"
    },
    {
    :abbr => :trioch,
    :name => "Sorsa"
    },
    {
    :abbr => :acthyp,
    :name => "Sorsa"
    },
    {
    :abbr => :numarq,
    :name => "Sorsa"
    },
    {
    :abbr => :vanvan,
    :name => "Sorsa"
    },
    {
    :abbr => :botste,
    :name => "Sorsa"
    },
    {
    :abbr => :embsch,
    :name => "Sorsa"
    },
    {
    :abbr => :acrsch,
    :name => "Sorsa"
    }
  ]

  def self.load_shit
	@@birds.each do |bird|
	  Bird.create(bird)
	end
  end
end
