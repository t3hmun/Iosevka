default: fonts

include makesupport.mk
PARAM_DEFAULT = FAST='$(FAST)' SUFFIX='$(SUFFIX)' VARNAME='$(VARNAME)' STYLE_COMMON='$(STYLE_COMMON)' STYLE_UPRIGHT='$(STYLE_UPRIGHT)' STYLE_ITALIC='$(STYLE_ITALIC)' VERSION='$(VERSION)' ARCPREFIX='$(ARCPREFIX)' NOLIG='$(NOLIG)' NOCHARMAP='$(NOCHARMAP)'
PARAM_SLAB = FAST='$(FAST)' SUFFIX='$(SUFFIX)-slab' VARNAME='$(VARNAME)' STYLE_COMMON='$(STYLE_COMMON)' STYLE_SUFFIX='slab' STYLE_UPRIGHT='$(STYLE_UPRIGHT)' STYLE_ITALIC='$(STYLE_ITALIC)' VERSION='$(VERSION)' ARCPREFIX='$(ARCPREFIX)' NOLIG='$(NOLIG)' NOCHARMAP='$(NOCHARMAP)'

### Sometimes make will freak out and report ACCESS VIOLATION for me... so i have to add some repeation
LOOPS = 0 1 2

svgs : svgs-default svgs-slab
fonts : fonts-default fonts-slab
test  : test-default test-slab
snapshot  : snapshot-default snapshot-slab

# svgs
svgs-default : $(SCRIPTS) | $(OBJDIR) dist
	@$(MAKE) -f onegroup.mk svgs $(PARAM_DEFAULT)
svgs-slab : $(SCRIPTS) | $(OBJDIR) dist
	@$(MAKE) -f onegroup.mk svgs $(PARAM_SLAB)


# ttfs
fonts-default : $(SCRIPTS) | $(OBJDIR) dist
	@$(MAKE) -f onegroup.mk fonts $(PARAM_DEFAULT)
fonts-slab : $(SCRIPTS) | $(OBJDIR) dist
	@$(MAKE) -f onegroup.mk fonts $(PARAM_SLAB)


### USED FOR TESTING AND RELEASING
### DO NOT TOUCH!
# testdrive
test-default : fonts-default
	@$(MAKE) -f onegroup.mk test $(PARAM_DEFAULT)
test-slab : fonts-slab
	@$(MAKE) -f onegroup.mk test $(PARAM_SLAB)
	
# snapshot
snapshot-default : webfonts-default | snapshot/assets
	@$(MAKE) -f onegroup.mk snapshot $(PARAM_DEFAULT)
snapshot-slab : webfonts-slab | snapshot/assets
	@$(MAKE) -f onegroup.mk snapshot $(PARAM_SLAB)

# Webfonts
dist/webfonts : | dist
	@- mkdir $@
dist/webfonts/assets : |dist/webfonts
	@- mkdir $@
webfonts-default : fonts-default | dist/webfonts/assets
	@$(MAKE) -f onegroup.mk webfonts $(PARAM_DEFAULT)
webfonts-slab : fonts-slab | dist/webfonts/assets
	@$(MAKE) -f onegroup.mk webfonts $(PARAM_SLAB)

# Pages
pages-default : fonts-default
	@$(MAKE) -f onegroup.mk pages $(PARAM_DEFAULT)
pages-slab : fonts-slab
	@$(MAKE) -f onegroup.mk pages $(PARAM_SLAB)

# Release
release-default : fonts-default
	@$(MAKE) -f onegroup.mk release $(PARAM_DEFAULT)
release-slab : fonts-slab
	@$(MAKE) -f onegroup.mk release $(PARAM_SLAB)

# Archives
archives-default : fonts-default
	@$(MAKE) -f onegroup.mk archives $(PARAM_DEFAULT)
archives-slab : fonts-slab
	@$(MAKE) -f onegroup.mk archives $(PARAM_SLAB)

# Releases
releasepack-default : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) pages-default pages-slab archives-default archives-slab VERSION=$(VERSION) \
		ARCPREFIX='std-'
releasepack-nl : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default archives-slab VERSION=$(VERSION) \
		ARCPREFIX='std-nl-' VARNAME='nl-' STYLE_COMMON='nl' NOCHARMAP='true'
releasepack-wcc : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default archives-slab VERSION=$(VERSION) \
		ARCPREFIX='std-wcc-' VARNAME='wcc-' STYLE_COMMON='cc' NOCHARMAP='true'

releasepack-hooky : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default VERSION=$(VERSION) \
		ARCPREFIX='var-hooky-' VARNAME='hooky-' STYLE_UPRIGHT='v-l-hooky v-i-hooky' NOCHARMAP='true'
releasepack-hooky-nl : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default VERSION=$(VERSION) \
		ARCPREFIX='var-hooky-nl-' VARNAME='hooky-nl-' STYLE_COMMON='nl' STYLE_UPRIGHT='v-l-hooky v-i-hooky' NOCHARMAP='true'

releasepack-zshaped : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default VERSION=$(VERSION) \
		ARCPREFIX='var-zshaped-' VARNAME='zshaped-' STYLE_UPRIGHT='v-l-zshaped v-i-zshaped' NOCHARMAP='true'
releasepack-zshaped-nl : $(SCRIPTS) | $(OBJDIR) dist
	$(MAKE) archives-default VERSION=$(VERSION) \
		ARCPREFIX='var-zshaped-nl-' VARNAME='zshaped-nl-' STYLE_COMMON='nl' STYLE_UPRIGHT='v-l-zshaped v-i-zshaped' NOCHARMAP='true'

release-all : releasepack-default releasepack-nl releasepack-wcc releasepack-hooky releasepack-zshaped releasepack-hooky-nl releasepack-zshaped-nl
fw : releasepack-default releasepack-wcc

webfonts : webfonts-default webfonts-slab

electronsnaps1: webfonts snapshot
	cd snapshot && electron getsnap.js --dir ../images
images/opentype.png: electronsnaps1
	optipng $@
images/languages.png: electronsnaps1
	optipng $@
images/preview-all.png: electronsnaps1
	optipng $@
images/weights.png: electronsnaps1
	optipng $@
images/variants.png: electronsnaps1
	optipng $@
images/matrix.png: electronsnaps1
	optipng $@
images/family.png: electronsnaps1
	optipng $@


sampleimages: images/family.png images/matrix.png images/weights.png images/variants.png images/opentype.png images/languages.png images/preview-all.png