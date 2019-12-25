require 'sinatra'
require 'natto'

get '/persons' do
  return 'Paramete Text is required' unless params['text']

  natto = Natto::MeCab.new

  person_names = []
  features = []
  person_names_index = 0
  features_index = 0
  natto.parse(params['text']) do |n|
    features[features_index] = n.feature
    features_index += 1
    next unless n.feature.include?('人名')

    if person_names == []
      person_names[person_names_index] = n.surface
    elsif features[features_index - 1].include?('人名')
      person_names[person_names_index] += n.surface
    else
      person_names_index += 1
      person_names[person_names_index] = n.surface
    end
  end

  person_names.to_json
end
