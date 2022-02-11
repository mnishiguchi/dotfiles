# Simplify the irb prompt and suppress some annoying auto-indent behavior.
# https://www.railstutorial.org/book/rails_flavored_ruby#code-irbrc
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:AUTO_INDENT

# https://til.hashrocket.com/posts/09139e5206-enable-commands-history-on-rails-console-and-irb
IRB.conf[:SAVE_HISTORY] = 200
IRB.conf[:HISTORY_FILE] = '~/.irb-history'
