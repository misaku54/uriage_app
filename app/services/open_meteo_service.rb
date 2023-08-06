# 天気API連携ロジックモデル
class OpenMeteoService
  def get_weather_info(target_date, **options)   # 引数で受け取る場合の** キーワード引数をハッシュとして受け取る。
    method = build_query(target_date, **options) # 引数を渡す場合の**　　 ハッシュをキーワード引数に変換する。
    call_api(method)
  end

  private

  def build_query(target_date, **options)
    {
    latitude: 31.9167,
    longitude: 131.4167,
    hourly: 'temperature_2m,precipitation_probability,precipitation_probability,weathercode',
    daily: 'weathercode,temperature_2m_max,temperature_2m_min',
    timezone: 'Asia%2FTokyo',
    start_date: target_date,
    end_date: target_date,
    }.merge(options).map{ |key, value| "#{key}=#{value}" }.join('&')
  end

  def call_api(method)
    uri = URI.parse("https://api.open-meteo.com/v1/forecast?#{method}")
    http_client = Net::HTTP.new(uri.host, uri.port)
    http_client.use_ssl = true
    
    get_request = Net::HTTP::Get.new("#{uri.path}?#{uri.query}")
    get_request['Content-Type'] = 'application/json'
    get_request['charset'] = 'UTF-8'
    response = http_client.request(get_request)

    case response
    when Net::HTTPSuccess
      # JSON形式をハッシュに変換し、with_indifferent_accessでシンボルでも文字列でもハッシュにアクセスできるようにした
      JSON.parse(response.body).with_indifferent_access
    else
      raise StandardError.new(response.body)
    end
  end
end