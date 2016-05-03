require "oj"
require "rest_client"
require "gitsearch/external_service/rest_client_dispatcher"

module ExternalService
  class GithubDispatcher < RestClientDispatcher

    API_URI = "https://api.github.com/search/repositories"

    def initialize(sleep_time_seconds=5, client=RestClient)
      @client = client

      super(sleep_time_seconds)
    end


    # Le but ici n'étant pas de faire un moteur de recherche versatile pour github mais simplement
    # de pratiquer mes techniques d'injection de dépendances (les tests seront aussi affectés)
    # La query doit avoir la syntaxe désirée par l'API.
    # https://help.github.com/articles/search-syntax/
    def dispatch(method, query)
      super() do

        response = @client.public_send(
          method,
          "#{API_URI}?#{query.sub(%r{^/},"")}",
          content_type: :json,
          accept: :json
        )

        sleep 10 if response.headers[:x_ratelimit_remaining].to_i < 2

        # Cacher le parsing du JSON dans le dispatcher
        # Si notre client plante, nous pourrions recevoir du HTML en réponse plutôt que du JSON
        # Le dispatcher est donc prêt à attraper une exception venant d'OJ.
        Oj.load(response)["items"]
      end
    end
  end
end
