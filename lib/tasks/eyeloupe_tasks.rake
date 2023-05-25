desc "Compiling TailwindCSS files"
task :tailwind_watch do
  require "tailwindcss-rails"
  system "#{Tailwindcss::Engine.root.join("exe/tailwindcss")} \
         -i #{Eyeloupe::Engine.root.join("app/assets/stylesheets/application.tailwind.css")} \
         -o #{Eyeloupe::Engine.root.join("app/assets/builds/eyeloupe.css")} \
         -c #{Eyeloupe::Engine.root.join("config/tailwind.config.js")} \
         --minify -w"
end