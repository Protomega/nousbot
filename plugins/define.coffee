## standard dictionary (NinjaWords) scraper by TheEternalAbyss and eggsby

module.exports = (app) ->
    return {
        start   : (nous) ->
            app.util.command nous, "define", (input) ->
                url = "http://ninjawords.com/#{(encodeURIComponent input.msg)}"
                app.util.parse url, (err, $, data) ->
                  try
                    defs = []
                    suggested = $("dt.title-word a").text
                    if suggested == input.msg
                      $('div.definition').each (def) ->
                        def = ((def.striptags).match /deg;(.*)/) # match after the bullets
                        if def and def.length > 1
                          def = def[1]
                          defs.push def
                      if defs
                        defstring = ""
                        defstring += "#{i+1} #{def} " for def, i in defs
                        response = "#{input.msg}: #{defstring}"
                    else
                      response = "Perhaps you meant #{suggested}"
                  catch err
                    response = "#{input.msg} is not in the dictionary."
                  nous.say(input.to, response)
    }