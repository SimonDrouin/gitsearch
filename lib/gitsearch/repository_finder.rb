require "gitsearch/external_service/github_dispatcher"

class RepositoryFinder
  def search(query, language: nil)
    params = "q=#{query}"
    params += "+language:#{language}" if language

    # Il pourrait y avoir un loop d'offsets ici car Github ne retourne que 100 items à la fois.
    # Le but du projet n'étant pas de remplir une base de donnée aberrante. 100 items suffiront.
    # Le dispatcher est toutefois prêt à gérer les rate limits d'une série d'appels.
    dispatcher = ExternalService::GithubDispatcher.new
    dispatcher.dispatch(:get, params)
  end
end