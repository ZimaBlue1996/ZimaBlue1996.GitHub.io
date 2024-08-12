OS := $(shell uname -s)
# 根据系统类型来执行不同的指令
ifeq ($(OS),Linux)
	CURRENT_DATE=$(shell date +%Y-%m-%d)
	CN_FONT="WenQuanYi Zen Hei"
else ifeq ($(OS),Windows_NT)
	CURRENT_DATE=$(shell powershell Get-Date -Format yyyy-MM-dd)
	CN_FONT="Microsoft YaHei"
else
	@echo "Unsupported platform: $(OS)"
endif

# 获取当前路径和时间
CURRENT_DIR  := $(shell pwd)

# 指定latex模板路径
TEMPLATE := $(CURRENT_DIR)/eisvogel.latex

# 设置作者名称
AUTHOR := "ZGMicro.com"

SRC := $()

# 设置参数
FLAGS := -f markdown+tex_math_single_backslash 
FLAGS += --pdf-engine=xelatex  
FLAGS += --table-of-contents 
FLAGS += --number-sections 
FLAGS += -V colorlinks 
FLAGS += -V CJKmainfont=$(CN_FONT)
FLAGS += -V toc-own-page="true"
FLAGS += --highlight-style=tango
FLAGS += --metadata author=$(AUTHOR)
FLAGS += --metadata toc="true"
FLAGS += --metadata date=$(CURRENT_DATE)
FLAGS += --metadata titlepage="true"

# 获取所有的 .md 文件列表
MD_FILES := $(wildcard *.md)

# 将 .md 文件名替换为相应的 .pdf 文件名
PDF_FILES := $(patsubst %.md,%.pdf,$(MD_FILES))

# 默认规则，生成所有的 PDF 文件
all: $(PDF_FILES)

# 生成pdf文件
%.pdf: %.md
	@echo "OS: $(OS)"
	@echo "date: $(CURRENT_DATE)"
	@echo "font: $(CN_FONT)"
	pandoc $<  -o $@   $(FLAGS) --metadata title=$*  --template=$(TEMPLATE)

.PHONY:  all

# 清除生成的pdf文件
clean:
	rm -f *.pdf

