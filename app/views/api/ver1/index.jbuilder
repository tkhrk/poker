json.ignore_nil!
json.set! :result do
  json.array! @result, :card, :hand, :best
end

unless @errors.empty?
  json.set! :error do
    json.array! @errors
  end
end
