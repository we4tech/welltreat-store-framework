# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "welltreat-store-framework"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nhm tanveer hossain khan"]
  s.date = "2012-07-11"
  s.description = "WellTreat Store Framework"
  s.email = ["hasan83bd@gmail.com"]
  s.extra_rdoc_files = [
    "README.md"
  ]
  s.files = [
    "lib/generators/flexi_model/install/install_generator.rb",
    "lib/generators/flexi_model/install/templates/create_flexi_model_collections.rb",
    "lib/generators/flexi_model/install/templates/create_flexi_model_collections_fields.rb",
    "lib/generators/flexi_model/install/templates/create_flexi_model_fields.rb",
    "lib/generators/flexi_model/install/templates/create_flexi_model_records.rb",
    "lib/generators/flexi_model/install/templates/create_flexi_model_values.rb",
    "lib/welltreat_store_framework.rb",
    "lib/welltreat_store_framework/configuration.rb",
    "lib/welltreat_store_framework/controller.rb",
    "lib/welltreat_store_framework/core.rb",
    "lib/welltreat_store_framework/haml_renderer.rb",
    "lib/welltreat_store_framework/haml_renderer/lorem_helper.rb",
    "lib/welltreat_store_framework/haml_renderer/partial.rb",
    "lib/welltreat_store_framework/haml_renderer/paths.rb",
    "lib/welltreat_store_framework/haml_renderer/tags_helper.rb",
    "lib/welltreat_store_framework/rack_server.rb",
    "lib/welltreat_store_framework/store_app.rb",
    "sample/hello-store/assets/javascripts/app.js",
    "sample/hello-store/controllers/home.rb",
    "sample/hello-store/controllers/products.rb",
    "sample/hello-store/models/product.rb",
    "sample/hello-store/mount.rb",
    "sample/hello-store/views/home/index.haml",
    "sample/hello-store/views/layouts/default.html.haml",
    "sample/hello-store/views/products/_product.html.haml",
    "sample/hello-store/views/products/index.haml",
    "sample/hello-store/views/products/show.html.haml",
    "spec/fixtures/schema.rb",
    "spec/lib/welltreat_store_framework/configuration_spec.rb",
    "spec/lib/welltreat_store_framework/core_spec.rb",
    "spec/lib/welltreat_store_framework/haml_renderer/context_spec.rb",
    "spec/lib/welltreat_store_framework/store_app_spec.rb",
    "spec/lib/welltreat_store_framework_spec.rb",
    "spec/sample/controllers/products_spec.rb",
    "spec/spec_helper.rb",
    "spec/spec_helper/active_record.rb",
    "spec/spec_helper/models.rb",
    "spec/spec_helper/rspec.rb"
  ]
  s.homepage = "https://github.com/we4tech/welltreat-store-framework/"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "Build store just like your another web development project."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.2.0"])
      s.add_runtime_dependency(%q<haml>, [">= 0"])
      s.add_runtime_dependency(%q<flexi_model>, [">= 0"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<activesupport>, ["~> 3.2.0"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<flexi_model>, [">= 0"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<activesupport>, ["~> 3.2.0"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<flexi_model>, [">= 0"])
  end
end

