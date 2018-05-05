require 'rest-client'
require 'json'

class Bitmex

	DOMAIN = 'https://www.bitmex.com'
	API_POINT = '/api/v1/'

	def initialize
		keys = File.read('keys.txt').split("\n")

		@public_key = keys[1]
		@private_key = keys[2]
	end

	def make_order(direction, price)
		#
	end

	def move_order(id)
		#
	end

	def cancel_order(id)
		#
	end

	def orders
		endpoint = 'order'
		payload = '?filter={"symbol": "XBTUSD", "open": true}'
		expires = make_expires
		signature = crypt(:get, endpoint, payload, expires)

		decode request(:get, request_url(endpoint, payload), headers(expires, signature))
	end

	def position
		endpoint = 'position'
		payload = '?filter={"symbol": "XBTUSD"}'
		expires = make_expires
		signature = crypt(:get, endpoint, payload, expires)

		raw_data = request(:get, request_url(endpoint, payload), headers(expires, signature))

		decode(raw_data).first
	end

	def deposit
		endpoint = 'user/walletSummary'
		payload = ''
		expires = make_expires
		signature = crypt(:get, endpoint, payload, expires)

		raw_data = request(:get, request_url(endpoint, payload), headers(expires, signature))

		decode(raw_data)[4]['marginBalance'].to_f / 100000000
	end

	private

	def crypt(method, endpoint, payload, expires)
		method = method.to_s.upcase

		data = "#{method}#{API_POINT}#{endpoint}"

		if method == 'GET'
			data << "#{payload}#{expires}"
		else
			data << "#{expires}#{payload}"
		end

		OpenSSL::HMAC.hexdigest('SHA256', @private_key, URI.encode(data))
	end

	def request_url(endpoint, payload)
		URI.encode("#{DOMAIN}#{API_POINT}#{endpoint}#{payload}")
	end

	def headers(expires, signature)
		{
			'api-expires': expires,
			'api-key': @public_key,
			'api-signature': signature
		}
	end

	def request(method, url, headers, payload = nil)
		RestClient::Request.execute(
			method: method,
			url: url,
			headers: headers,
			payload: payload
		)
	end

	def make_expires
		5.minutes.since.to_i
	end

	def decode(data)
		ActiveSupport::JSON.decode(data)
	end
end

BITMEX = Bitmex.new