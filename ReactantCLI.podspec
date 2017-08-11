Pod::Spec.new do |spec|
  spec.name         = 'ReactantCLI'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/Brightify/ReactantCLI'
  spec.authors      = { 'Tadeas Kriz' => 'tadeas@brightify.org', 'Matous Hybl' => 'matous@brightify.org' }
  spec.summary      = 'Generator of Reactant enabled projects'
  spec.source       = { :git => 'https://github.com/Brightify/ReactantCLI.git', :branch => 'components' }
  spec.source_files = ['Sources/ProjectGeneratorFramework/**/*.swift']
  spec.framework    = 'Foundation'
  spec.osx.deployment_target       = '10.10'
  spec.dependency 'SwiftyTextTable'
end
