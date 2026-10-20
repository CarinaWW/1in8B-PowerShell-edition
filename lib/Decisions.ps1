# Auto-converted from src/engine/ (original repo) decisions.js (interactive life decisions).
# Each choice.apply mutates $state and returns a localized result text.


$script:DECISIONS = [ordered]@{
  # Age 2: Temperament
  temper = @{
    id = 'temper'
    age = 2
    title = @{
      ja = '2歳：外の世界へ'
      en = 'Two years old, the world outside'
      zh = '2岁：外面的世界'
    }
    body = @{
      ja = 'しっかり歩けるようになり、音や景色であふれる世界へ踏み出しました。まず何に心をひかれますか？'
      en = 'You take your first steady steps outside into a vast world full of sights and sounds. What draws your attention first?'
      zh = '你迈着逐渐稳健的步子走向外面，世界充满新奇的声音和景象。什么最先吸引你？'
    }
    fact = @{
      ja = '気質には遺伝と幼少期の経験が影響します。双生児研究では性格の違いの約40%が遺伝によるとされています（Vukasović・Bratko 2015）。'
      en = 'Temperament is shaped both by genetics and early experience. Twin studies show about 40% of personality variance is hereditary (Vukasović & Bratko 2015).'
      zh = '气质受遗传和早期经历共同影响。双胞胎研究显示，性格差异约有40%来自遗传（Vukasović、Bratko，2015）。'
    }
    choices = @(
      @{
        id = 'curious'
        label = @{
          ja = '小石や葉、小さな虫をじっと観察する'
          en = 'Sit and examine pebbles, leaves, and tiny insects with intense curiosity'
          zh = '好奇地观察石子、树叶和小虫'
        }
        sub = @{ ja = '知性 +5、幸福 +2';  en = 'Smarts +5, Happiness +2';  zh = '智力 +5，幸福 +2' }
        apply = { param($state)
          $state.stats.smarts += 5
          $state.stats.happiness += 2
          return @{
            ja = '身の回りの小さな不思議に夢中になり、静かに何時間も観察しました。'
            en = 'You spent hours quietly fascinated by the small wonders of the world.'
            zh = '你静静地观察了好几个小时，沉醉于身边的小小奇迹。'
          }
        }
      }
      @{
        id = 'active'
        label = @{
          ja = '音や動物、動くものに向かって走る'
          en = 'Run with all your might toward sounds, animals, and moving things'
          zh = '全力奔向声音、动物和会动的东西'
        }
        sub = @{ ja = '健康 +6、活発な気質';  en = 'Health +6, Energetic';  zh = '健康 +6，充满活力' }
        apply = { param($state)
          $state.stats.health += 6
          return @{
            ja = '軽やかな足で近所じゅうを元気に探検しました。'
            en = 'Your quick legs carried you excitedly all around the neighborhood.'
            zh = '你迈着轻快的步子，兴奋地探索街坊的每个角落。'
          }
        }
      }
      @{
        id = 'empathetic'
        label = @{
          ja = '泣いている子に近づき、そっと手を差し出す'
          en = 'Walk over and gently reach out a hand to another crying toddler'
          zh = '走近哭泣的孩子，轻轻伸出手安慰'
        }
        sub = @{ ja = '社交 +6、幸福 +4';  en = 'Social +6, Happiness +4';  zh = '社交 +6，幸福 +4' }
        apply = { param($state)
          $state.stats.social += 6
          $state.stats.happiness += 4
          return @{
            ja = '幼いころから周りの人に温かさと思いやりを示しました。'
            en = 'You showed innate warmth and kindness to those around you from a tender age.'
            zh = '你从小就展现出对他人的温暖和体贴。'
          }
        }
      }
      @{
        id = 'resilient'
        label = @{
          ja = '転んでも泣かずに立ち上がる'
          en = 'Get straight back up after tumbling down without shedding a tear'
          zh = '跌倒后不哭，立刻自己站起来'
        }
        sub = @{ ja = '忍耐力 +5、健康 +3';  en = 'Resilience +5, Health +3';  zh = '韧性 +5，健康 +3' }
        apply = { param($state)
          $state.stats.health += 3
          $state.stats.smarts += 3
          return @{
            ja = 'くじけずに立ち直る力が、あなたの持ち味になりました。'
            en = 'Undaunted resilience became a hallmark of your growing spirit.'
            zh = '不屈不挠的精神逐渐成为你的特点。'
          }
        }
      }
    )
  }

  # Age 6: Primary schooling
  school1 = @{
    id = 'school1'
    age = 6
    title = @{
      ja = '6歳：学校への道'
      en = 'Age 6: The path to school'
      zh = '6岁：上学之路'
    }
    body = @{
      ja = '小学校に入る年です。多くの子が通学を始めますが、貧しい地域では学費や家の仕事が壁になります。'
      en = 'It is time for first grade. Many children your age start school, but in poorer communities, school fees and family chores compete for a child''s day.'
      zh = '到了读一年级的年纪。许多同龄人开始上学，但在贫困地区，学费和家务会占去孩子的一天。'
    }
    fact = @{
      ja = '世界の就学予想年数は約13年に伸びましたが（UNDP）、貧困で学べない子は今も数千万人います。'
      en = 'Expected years of schooling globally has risen to nearly 13 years (UNDP), yet tens of millions of children still miss out due to poverty.'
      zh = '全球预期受教育年限已接近13年（UNDP），但仍有数千万儿童因贫困失学。'
    }
    choices = @(
      @{
        id = 'plea_school'
        label = @{
          ja = '学校に行き、読み書きを学びたいと頼む'
          en = 'Ask earnestly to go to school and learn to read'
          zh = '认真请求去学校学习读写'
        }
        sub = @{ ja = '知性 +10、小学校へ';  en = 'Smarts +10, Enters Primary';  zh = '智力 +10，进入小学' }
        apply = { param($state)
          $successRate = $(if ($state.q -ge 2) { 0.95 } else { 0.65 })
          if (Test-Chance $successRate) {
            $state.stats.educationLevel = 1
            $state.stats.smarts += 10
            $state.job = 'Học sinh tiểu học'
            $state.jobId = 'student_prim'
            return @{
              ja = '両親が本代を切り詰めて用意し、胸を張って1年生になりました！'
              en = 'Your parents scrimped and saved for books, and you started first grade with pride!'
              zh = '父母省吃俭用买齐课本，你自豪地成为一年级学生！'
            }
          } else {
            $state.stats.social += 5
            $state.job = 'Phụ giúp gia đình'
            return @{
              ja = '学費を払えず家を手伝うことになりましたが、できる限り独学を続けました。'
              en = 'School fees were out of reach; you stayed home helping the family while teaching yourself what you could.'
              zh = '家里负担不起学费，你留在家中帮忙，同时尽力自学。'
            }
          }
        }
      }
      @{
        id = 'help_family'
        label = @{
          ja = '家事、農作業、家業を手伝う'
          en = 'Stay home to help with chores, farm work, or family trade'
          zh = '留在家里帮忙做家务、务农或经营'
        }
        sub = @{ ja = '社交 +6、家計に少し貢献';  en = 'Social +6, Small family income';  zh = '社交 +6，少量家庭收入' }
        apply = { param($state)
          $state.stats.social += 6
          $state.stats.wealth += 50
          $state.job = 'Lao động phụ việc'
          return @{
            ja = '苦しい家計を支える、頼りになる家族の一員になりました。'
            en = 'You became a cherished extra pair of helping hands for your struggling family.'
            zh = '你成为家里可靠的帮手，为艰难的生活分担压力。'
          }
        }
      }
    )
  }

  # Age 12: Middle school transition
  school2 = @{
    id = 'school2'
    age = 12
    title = @{
      ja = '12歳：中学進学の分かれ道'
      en = 'Age 12: Middle school crossroads'
      zh = '12岁：初中的岔路口'
    }
    body = @{
      ja = '小学校を終えました。進学には学費や制服、遠くまで通う手間がかかります。'
      en = 'Primary school is behind you. Continuing to secondary education requires tuition, uniforms, and longer travel.'
      zh = '小学毕业了。继续读中学需要学费、校服，还可能要走更远的路。'
    }
    fact = @{
      ja = '前期中等教育の修了率は、低所得国では約40%、高所得国では95%以上です（UNESCO）。'
      en = 'In low-income nations, lower-secondary completion rates hover around 40%, compared to 95%+ in high-income countries (UNESCO).'
      zh = '低收入国家的初中完成率约为40%，高收入国家则超过95%（UNESCO）。'
    }
    choices = @(
      @{
        id = 'middle_school'
        label = @{
          ja = '中学校に進み、勉学に励む'
          en = 'Continue onto middle school with diligence'
          zh = '继续读初中，勤奋学习'
        }
        sub = @{ ja = '知性 +12、中学校へ';  en = 'Smarts +12, Enters Middle School';  zh = '智力 +12，进入初中' }
        apply = { param($state)
          $state.stats.educationLevel = 2
          $state.stats.smarts += 12
          $state.job = 'Học sinh cấp hai'
          $state.jobId = 'student_sec'
          return @{
            ja = '文学や数学、理科を学ぶことに胸をふくらませて中学校に入りました！'
            en = 'You stepped into middle school, eager to explore literature, mathematics, and science!'
            zh = '你满怀期待地进入初中，探索文学、数学和科学！'
          }
        }
      }
      @{
        id = 'apprenticeship'
        label = @{
          ja = '商売や修理など、実用的な技術を学ぶ'
          en = 'Learn a practical trade, mechanic skills, or commerce'
          zh = '学习手艺、维修或经商技能'
        }
        sub = @{ ja = '実用技能、資産 +$200';  en = 'Practical skill, Wealth +$200';  zh = '实用技能，财富 +$200' }
        apply = { param($state)
          $state.stats.wealth += 200
          $state.stats.social += 5
          $state.job = 'Học nghề thợ sửa chữa'
          $state.jobId = 'apprentice'
          return @{
            ja = '熟練職人の弟子となり、一生役立つ技術を身につけました。'
            en = 'You apprenticed under a master craftsman, gaining practical skills that will last a lifetime.'
            zh = '你跟随老师傅学艺，掌握了终身受用的实用技能。'
          }
        }
      }
    )
  }

  # Age 15: High school / Career
  school3 = @{
    id = 'school3'
    age = 15
    title = @{
      ja = '15歳：人生の転機'
      en = 'Age 15: The turning point'
      zh = '15岁：人生转折点'
    }
    body = @{
      ja = '15歳になると、普通高校、職業学校、就職へと、それぞれの道が分かれていきます。'
      en = 'At fifteen, paths diverge: some head to academic high schools, others to vocational trade institutes, while many enter the workforce directly.'
      zh = '十五岁，人生道路开始分岔：有人读普通高中，有人读职业学校，也有人直接工作。'
    }
    fact = @{
      ja = '中欧の職業訓練制度では若者の失業率が5%未満の一方、多くの地域では20%を超えます。'
      en = 'Dual vocational training systems keep youth unemployment under 5% in Central Europe, while general youth unemployment exceeds 20% in many regions.'
      zh = '中欧的双元制职业培训使青年失业率低于5%，而许多地区的青年失业率超过20%。'
    }
    choices = @(
      @{
        id = 'high_school'
        label = @{
          ja = '普通高校へ進み、大学入試を目指す'
          en = 'Academic High School (aiming for college entrance)'
          zh = '就读普通高中，准备大学入学考试'
        }
        sub = @{ ja = '知性 +15、大学進学の道';  en = 'Smarts +15, University track';  zh = '智力 +15，大学升学路线' }
        apply = { param($state)
          $state.stats.educationLevel = 3
          $state.stats.smarts += 15
          $state.job = 'Học sinh cấp ba'
          $state.jobId = 'student_high'
          return @{
            ja = '大学入試を目指し、夜遅くまで勉強する高校生活を始めました。'
            en = 'You embarked on demanding high school years, studying late into the evening for college exams.'
            zh = '你开始了紧张的高中生活，为大学入学考试学习到深夜。'
          }
        }
      }
      @{
        id = 'vocational'
        label = @{
          ja = '職業学校で現代の実務技能を学ぶ'
          en = 'Vocational Technical School (hands-on modern trades)'
          zh = '就读职业技术学校，学习实用技术'
        }
        sub = @{ ja = '安定した職、資産 +$400';  en = 'Job stability, Wealth +$400';  zh = '工作稳定，财富 +$400' }
        apply = { param($state)
          $state.stats.educationLevel = 2.5
          $state.stats.wealth += 400
          $state.job = 'Kỹ thuật viên thực tập'
          $state.jobId = 'technician_trainee'
          return @{
            ja = '需要の高い技術を習得し、有望な実習先を見つけました。'
            en = 'You mastered sought-after technical skills and secured a promising internship.'
            zh = '你掌握了市场需要的技术，获得了一份前景不错的实习。'
          }
        }
      }
      @{
        id = 'workforce'
        label = @{
          ja = '工場・商売・販売の仕事を始める'
          en = 'Enter the workforce immediately (factory, trade, sales)'
          zh = '直接工作，从事工厂、贸易或销售工作'
        }
        sub = @{ ja = 'すぐに収入 +$800';  en = 'Immediate income +$800';  zh = '即时收入 +$800' }
        apply = { param($state)
          $state.stats.wealth += 800
          $state.job = 'Công nhân / Nhân viên bán hàng'
          $state.jobId = 'worker'
          return @{
            ja = '初めての給料を両親に渡し、家計を支えることに誇りを感じました。'
            en = 'You took immense pride in handing your first monthly paycheck to help support your parents.'
            zh = '你把第一份工资交给父母，能为家庭出力让你十分自豪。'
          }
        }
      }
    )
  }

  # Age 18: College & Adulthood
  college = @{
    id = 'college'
    age = 18
    title = @{
      ja = '18歳：進学か就職か'
      en = 'Age 18: Higher Education or Career?'
      zh = '18岁：升学还是就业？'
    }
    body = @{
      ja = '成人の節目、18歳になりました。ここでの選択が、これから何十年にも影響します。'
      en = 'Eighteen arrives: the legal threshold of adulthood. The choices you make now will ripple through the decades ahead.'
      zh = '十八岁，迈入成年的门槛。现在的选择将影响今后几十年的人生。'
    }
    fact = @{
      ja = '世界銀行によると、高等教育を1年長く受けるごとの所得上昇率は世界平均で14%です。'
      en = 'According to the World Bank, each additional year of tertiary education yields an average income premium of 14% globally.'
      zh = '据世界银行统计，全球每增加一年高等教育，收入平均提高14%。'
    }
    choices = @(
      @{
        id = 'go_uni'
        label = @{
          ja = '大学で理工・医学・経営・人文などを学ぶ'
          en = 'Attend University (STEM, Medicine, Business, Humanities)'
          zh = '进入大学学习理工、医学、商科或人文'
        }
        sub = @{ ja = '知性 +20、学位取得へ';  en = 'Smarts +20, Degree pathway';  zh = '智力 +20，学位路线' }
        apply = { param($state)
          $state.stats.educationLevel = 4
          $state.stats.smarts += 20
          $state.job = 'Sinh viên Đại học'
          $state.jobId = 'student_uni'
          return @{
            ja = '合格通知を手に、希望と意欲に満ちて大学の門をくぐりました！'
            en = 'With your acceptance letter in hand, you stepped onto campus full of ambition and hope!'
            zh = '你手握录取通知书，带着雄心与希望踏入校园！'
          }
        }
      }
      @{
        id = 'start_job'
        label = @{
          ja = '専門職や事務の仕事を始める'
          en = 'Start a professional job / office career'
          zh = '开始专业工作或办公室职业生涯'
        }
        sub = @{ ja = '資産 +$1,500、職務経験';  en = 'Wealth +$1,500, Career experience';  zh = '财富 +$1,500，职业经验' }
        apply = { param($state)
          $state.stats.wealth += 1500
          $state.job = 'Nhân viên văn phòng'
          $state.jobId = 'office_worker'
          return @{
            ja = '職場に素早くなじみ、経済的な安定を築き始めました。'
            en = 'You adapted swiftly to workplace dynamics and began building financial stability.'
            zh = '你很快适应了职场，开始建立稳定的经济基础。'
          }
        }
      }
      @{
        id = 'travel_abroad'
        label = @{
          ja = '海外での仕事・移住・奨学金を探す'
          en = 'Seek opportunities abroad (working holiday, migration, scholarship)'
          zh = '寻找海外工作、移民或奖学金机会'
        }
        sub = @{ ja = '国際経験、収入増';  en = 'Global experience, Higher earnings';  zh = '国际经验，更高收入' }
        apply = { param($state)
          $state.stats.wealth += 2500
          $state.stats.smarts += 10
          $state.flags.abroad = $true
          return @{
            ja = '異国で働き、故郷の家族へ仕送りを送りました。'
            en = 'You arrived in a foreign country, sending back generous remittances to your family back home.'
            zh = '你来到异国工作，将收入寄回家中，支持家人。'
          }
        }
      }
    )
  }

  # Age 26: Love & Marriage
  love = @{
    id = 'love'
    age = 26
    title = @{
      ja = '26歳：恋愛と約束'
      en = 'Age 26: Romance and Commitment'
      zh = '26岁：爱情与承诺'
    }
    body = @{
      ja = '互いに理解し、励まし合える大切な人に出会いました。結婚や二人の未来を考え始めます。'
      en = 'You have met someone truly special who understands and inspires you. Thoughts turn toward marriage and shared futures.'
      zh = '你遇到了理解你、鼓励你的特别之人，开始考虑婚姻和共同的未来。'
    }
    fact = @{
      ja = '平均初婚年齢は南アジアやアフリカの一部では20代前半、西欧や東アジアでは33歳を超えます。'
      en = 'The average age at first marriage varies from early twenties in parts of South Asia/Africa to past 33 in Western Europe and East Asia.'
      zh = '平均初婚年龄因地区而异：南亚和非洲部分地区在二十岁出头，西欧和东亚则超过33岁。'
    }
    choices = @(
      @{
        id = 'marry'
        label = @{
          ja = '結婚式を挙げ、一緒に家庭を築く'
          en = 'Tie the knot in a joyous ceremony and build a family together'
          zh = '举行婚礼，共同建立家庭'
        }
        sub = @{ ja = '幸福 +15、結婚';  en = 'Happiness +15, Married';  zh = '幸福 +15，结婚' }
        apply = { param($state)
          $state.family.partner = @{ name = 'Người bạn đời'; alive = $true }
          $state.stats.happiness += 15
          return @{
            ja = '晴れた結婚式の日、大切な人たちに囲まれて誓いを交わしました。'
            en = 'Surrounded by loved ones, you exchanged heartfelt vows on a sunlit wedding day.'
            zh = '在阳光明媚的婚礼上，你们在亲友的见证下交换真挚的誓言。'
          }
        }
      }
      @{
        id = 'focus_career'
        label = @{
          ja = '自分の成長、貯蓄、仕事を優先する'
          en = 'Prioritize personal growth, financial goals, and career momentum'
          zh = '优先考虑个人成长、财务目标和事业'
        }
        sub = @{ ja = '資産 +$3,000、自立';  en = 'Wealth +$3,000, Independence';  zh = '财富 +$3,000，独立' }
        apply = { param($state)
          $state.stats.wealth += 3000
          $state.stats.smarts += 5
          return @{
            ja = '努力が実り、昇進と経済的自立を手にしました。'
            en = 'Your dedication yielded rapid promotions and financial independence.'
            zh = '专注与努力带来了迅速的晋升和经济独立。'
          }
        }
      }
    )
  }

  # Age 35: Business or House investment
  midlife = @{
    id = 'midlife'
    age = 35
    title = @{
      ja = '35歳：安定か挑戦か'
      en = 'Age 35: Security or Adventure?'
      zh = '35岁：安稳还是冒险？'
    }
    body = @{
      ja = '働いて貯めた資金を前に、家計の大きな分かれ道に立っています。'
      en = 'With hard-earned savings accumulated, you stand at a major financial crossroads for your household.'
      zh = '辛勤工作积攒了一笔钱，你站在家庭财务的重要岔路口。'
    }
    fact = @{
      ja = '世界の70%以上の世帯では住宅が最大の資産であり、起業も世代を超えた上昇のきっかけになります。'
      en = 'Home ownership represents the largest asset for over 70% of households globally, while entrepreneurship drives generational upward mobility.'
      zh = '全球超过70%的家庭以住房为最大资产，而创业也能推动代际向上流动。'
    }
    choices = @(
      @{
        id = 'buy_home'
        label = @{
          ja = '家を買い、家族の安定を築く'
          en = 'Purchase a family home for stability and enduring peace of mind'
          zh = '购买家庭住房，获得稳定和安心'
        }
        sub = @{ ja = '幸福 +12、持ち家';  en = 'Happiness +12, Homeowner';  zh = '幸福 +12，拥有住房' }
        apply = { param($state)
          $state.stats.happiness += 12
          $state.flags.ownsHome = $true
          return @{
            ja = '自分の家の鍵を初めて回したとき、大きな達成感に包まれました。'
            en = 'Turning the key to your own front door brought an overwhelming sense of accomplishment.'
            zh = '第一次转动自家大门的钥匙时，巨大的成就感涌上心头。'
          }
        }
      }
      @{
        id = 'start_biz'
        label = @{
          ja = '自分の事業を立ち上げる'
          en = 'Found your own enterprise / Launch a business venture'
          zh = '创立自己的企业或开展创业项目'
        }
        sub = @{ ja = '大きな利益の可能性、起業家へ';  en = 'High potential payoff, Entrepreneur';  zh = '高回报潜力，成为创业者' }
        apply = { param($state)
          if ((Test-Chance (0.65))) {
            $state.stats.wealth += 8000
            $state.stats.happiness += 10
            $state.job = 'Chủ doanh nghiệp'
            return @{
              ja = '事業が市場の需要に合い、期待以上の成功を収めました！'
              en = 'Your venture struck market demand and prospered beyond your fondest hopes!'
              zh = '你的事业恰好满足市场需求，取得了超出预期的成功！'
            }
          } else {
            $state.stats.wealth = [Math]::Max(0, $state.stats.wealth - 2000)
            $state.stats.happiness -= 5
            return @{
              ja = '厳しい景気で事業は苦戦しましたが、粘り強さを学びました。'
              en = 'A difficult economic climate tested your business, imparting invaluable resilience.'
              zh = '艰难的经济环境考验着你的生意，也让你学会了坚持。'
            }
          }
        }
      }
    )
  }

  # Age 42: Midlife Crisis
  mcrisis = @{
    id = 'mcrisis'
    age = 42
    title = @{
      ja = '42歳：人生の半ばで'
      en = 'Age 42: Midlife Crossroads'
      zh = '42岁：中年岔路口'
    }
    body = @{
      ja = '仕事と家の責任を背負い続け、疲れを感じています。若いころの夢や、本当に大切なものを考え直します。'
      en = 'Years of unrelenting duty to work and household have taken their toll. You pause, wondering where the youthful dreams went and what truly matters.'
      zh = '多年承担工作与家庭责任让你身心疲惫。你停下来，思考年轻时的梦想和真正重要的事。'
    }
    fact = @{
      ja = '145か国で幸福度のU字型変化が報告されています。40代で底を迎え、その後は上昇する傾向です（Blanchflower・Oswald）。'
      en = 'The human happiness curve is widely documented as U-shaped across 145 countries, bottoming out in the 40s before rising steadily in later life (Blanchflower & Oswald).'
      zh = '145个国家的研究记录了幸福感的U形曲线：四十多岁时较低，之后逐渐回升（Blanchflower、Oswald）。'
    }
    choices = @(
      @{
        id = 'reconnect'
        label = @{
          ja = '家族と気持ちを話し合い、一緒の時間を作る'
          en = 'Open up to your family and carve out dedicated time together'
          zh = '向家人敞开心扉，安排相处时间'
        }
        sub = @{ ja = '幸福 +10、社交 +10';  en = 'Happiness +10, Social +10';  zh = '幸福 +10，社交 +10' }
        apply = { param($state)
          $state.stats.happiness += 10
          $state.stats.social += 10
          return @{
            ja = '率直な会話で距離が縮まり、家庭に温かさと理解が戻りました。'
            en = 'Heartfelt talks dissolved the quiet distance; warmth and mutual understanding returned to your home.'
            zh = '坦诚的交谈消除了隔阂，温暖与理解重新回到家中。'
          }
        }
      }
      @{
        id = 'new_passion'
        label = @{
          ja = '昔からの趣味や新しい創作に取り組む'
          en = 'Pursue a long-cherished hobby or learn a new creative craft'
          zh = '投入心仪已久的爱好，学习新的创作技能'
        }
        sub = @{ ja = '知性 +8、幸福 +8';  en = 'Smarts +8, Happiness +8';  zh = '智力 +8，幸福 +8' }
        apply = { param($state)
          $state.stats.smarts += 8
          $state.stats.happiness += 8
          return @{
            ja = '創作に打ち込み、生きる意欲がよみがえりました。'
            en = 'Immersing yourself in a creative calling sparked a renewed zest for life.'
            zh = '沉浸于创作中，你重新燃起了生活的热情。'
          }
        }
      }
      @{
        id = 'focus_work'
        label = @{
          ja = '仕事に全力を注ぎ、収入を最大限に伸ばす'
          en = 'Double down on professional output and maximum income growth'
          zh = '加倍努力工作，追求收入增长'
        }
        sub = @{ ja = '資産 +$3,500、幸福 -3';  en = 'Wealth +$3,500, Happiness -3';  zh = '财富 +$3,500，幸福 -3' }
        apply = { param($state)
          $state.stats.wealth += 3500
          $state.stats.happiness = [Math]::Max(10, $state.stats.happiness - 3)
          return @{
            ja = '仕事の収入は最高潮に達し、疲れながらも暮らしの安心を得ました。'
            en = 'Your career peaked financially, providing security even through moments of fatigue.'
            zh = '职业收入达到高峰，虽然疲惫，却为生活提供了保障。'
          }
        }
      }
    )
  }

  # Age 62: Retirement
  retire = @{
    id = 'retire'
    age = 62
    title = @{
      ja = '62歳：退職の節目'
      en = 'Age 62: The Retirement Threshold'
      zh = '62岁：退休的门槛'
    }
    body = @{
      ja = '退職を考える年齢になりました。のんびり過ごしますか、それとも得意な仕事を続けますか？'
      en = 'You reach the statutory retirement age recognized in most nations. Will you step back to enjoy tranquil leisure, or keep active in your calling?'
      zh = '到了考虑退休的年纪。你会享受清闲，还是继续在熟悉的领域活跃？'
    }
    fact = @{
      ja = '寿命が延び、退職後は平均20～25年になります（OECD）。人とのつながりは認知機能の低下リスクを減らします。'
      en = 'Rising life expectancy means retirement now spans 20-25 years on average (OECD). Remaining socially connected reduces cognitive decline risks by 30%.'
      zh = '寿命延长使退休生活平均达到20至25年（OECD）。保持社交联系有助于降低认知衰退风险。'
    }
    choices = @(
      @{
        id = 'enjoy_leisure'
        label = @{
          ja = '退職し、庭仕事や家族との時間を楽しむ'
          en = 'Retire peacefully, tend your garden, and enjoy family time'
          zh = '安稳退休，打理花园，享受家庭时光'
        }
        sub = @{ ja = '幸福 +15、健康 +5';  en = 'Happiness +15, Health +5';  zh = '幸福 +15，健康 +5' }
        apply = { param($state)
          $state.job = 'Nghỉ hưu an nhàn'
          $state.stats.happiness += 15
          $state.stats.health += 5
          return @{
            ja = '目覚ましのない穏やかな朝と、家族の笑い声を楽しみました。'
            en = 'You savored calm mornings without alarms and warm moments with loved ones.'
            zh = '你享受着没有闹钟的宁静清晨，以及家人温暖的笑声。'
          }
        }
      }
      @{
        id = 'mentor_part'
        label = @{
          ja = '若手の指導役や非常勤の相談役を続ける'
          en = 'Stay on as a senior mentor or part-time advisor'
          zh = '继续担任资深导师或兼职顾问'
        }
        sub = @{ ja = '資産 +$1,500、知性 +5';  en = 'Wealth +$1,500, Smarts +5';  zh = '财富 +$1,500，智力 +5' }
        apply = { param($state)
          $state.stats.wealth += 1500
          $state.stats.smarts += 5
          $state.stats.social += 5
          return @{
            ja = '長年の知恵と落ち着いた助言が、若い仲間に喜ばれました。'
            en = 'Younger peers deeply valued your decades of wisdom and steady guidance.'
            zh = '年轻同事十分珍惜你多年的经验和沉稳的指导。'
          }
        }
      }
    )
  }

  # Age 74: Golden Years Sanctuary
  oldhome = @{
    id = 'oldhome'
    age = 74
    title = @{
      ja = '74歳：穏やかな暮らしの場'
      en = 'Age 74: The Golden Years Sanctuary'
      zh = '74岁：安享晚年的居所'
    }
    body = @{
      ja = '70代になり、体の動きもゆっくりになりました。これからの暮らしと支えをどう整えるか考えます。'
      en = 'Into your seventies, physical agility gently recedes. You consider how best to arrange your daily living and care for the peaceful years ahead.'
      zh = '进入七十多岁，行动逐渐缓慢。你开始考虑如何安排今后的生活与照护。'
    }
    fact = @{
      ja = '東アジアでは高齢者の60%以上が子どもと同居または近居し、北欧では充実した介護制度が自立生活を支えています（WHO）。'
      en = 'Over 60% of elders in East Asia live with or near children, whereas comprehensive eldercare systems in Northern Europe enable independent communal living (WHO).'
      zh = '东亚超过60%的老人和子女同住或住得很近，而北欧完善的养老体系支持独立生活（WHO）。'
    }
    choices = @(
      @{
        id = 'live_with_kids'
        label = @{
          ja = '親しい人たちのそばで、支え合って暮らす'
          en = 'Move closer to loved ones and share everyday support'
          zh = '搬到亲近的人身边，互相照应'
        }
        sub = @{ ja = '幸福 +16、社交 +12';  en = 'Happiness +16, Social +12';  zh = '幸福 +16，社交 +12' }
        apply = { param($state)
          $state.stats.happiness += 16
          $state.stats.social += 12
          return @{
            ja = '親しい人たちと助け合い、日々の暮らしに喜びを感じました。'
            en = 'Living close to loved ones brought daily cheer and caring support.'
            zh = '与亲近的人相互照应，日常生活充满了喜悦与关怀。'
          }
        }
      }
      @{
        id = 'own_home_stay'
        label = @{
          ja = '住み慣れた家で、自立した暮らしを続ける'
          en = 'Remain in your longtime home with cherished independence'
          zh = '留在熟悉的家中，保持独立生活'
        }
        sub = @{ ja = '安心、幸福 +8';  en = 'Peace of mind, Happiness +8';  zh = '安心，幸福 +8' }
        apply = { param($state)
          $state.stats.happiness += 8
          return @{
            ja = 'なじみの街で、穏やかないつもの暮らしを守りました。'
            en = 'You kept your tranquil daily routine in the sanctuary of your familiar neighborhood.'
            zh = '你在熟悉的社区里，保持着宁静的日常生活。'
          }
        }
      }
    )
  }

  # Age 19: Civic & Conscription Milestone
  service = @{
    id = 'service'
    age = 19
    title = @{
      ja = '19歳：社会への奉仕'
      en = 'Age 19: National Service & Civic Duty'
      zh = '19岁：服役与公民责任'
    }
    body = @{
      ja = '大人になり、兵役や地域への奉仕を考える時が来ました。どのように社会に貢献しますか？'
      en = 'Reaching young adulthood, the call to national military service or civil community contribution arrives. How do you choose to serve your society?'
      zh = '成年后，服兵役或参与社区服务的机会到来。你会如何为社会出力？'
    }
    fact = @{
      ja = '韓国、イスラエル、シンガポール、スイス、ベトナムなど約30か国で、12～36か月の徴兵制があります。'
      en = 'About 30 nations worldwide enforce mandatory military service (such as South Korea, Israel, Singapore, Switzerland, Vietnam), spanning 12 to 36 months.'
      zh = '韩国、以色列、新加坡、瑞士、越南等约30个国家实行义务兵役制，期限为12至36个月。'
    }
    choices = @(
      @{
        id = 'serve_proudly'
        label = @{
          ja = '兵役に就き、規律を身につける'
          en = 'Enlist in military service to forge iron discipline'
          zh = '参军服役，磨炼纪律'
        }
        sub = @{ ja = '健康 +10、仲間との絆 +8';  en = 'Health +10, Comradeship +8';  zh = '健康 +10，战友情 +8' }
        apply = { param($state)
          $state.stats.health += 10
          $state.stats.social += 8
          $state.flags.served = $true
          return @{
            ja = '厳しい訓練で忍耐力が育ち、一生の仲間を得ました。'
            en = 'Rigorous military training forged resilience and lifelong bonds of brotherhood.'
            zh = '严格的军事训练磨炼了韧性，也结下了终身的友谊。'
          }
        }
      }
      @{
        id = 'civil_service'
        label = @{
          ja = '地域の福祉やボランティアに参加する'
          en = 'Engage in community civil service and volunteer missions'
          zh = '参与社区服务和志愿活动'
        }
        sub = @{ ja = '知性 +6、社交 +8';  en = 'Smarts +6, Social +8';  zh = '智力 +6，社交 +8' }
        apply = { param($state)
          $state.stats.smarts += 6
          $state.stats.social += 8
          return @{
            ja = '福祉の現場で働き、人々の苦労への理解を深めました。'
            en = 'Serving at community welfare centers gave you profound empathy for human struggles.'
            zh = '社区福利中心的服务经历让你更理解人们的艰难处境。'
          }
        }
      }
    )
  }

  # Age 22: First Career Launch
  jobhunt = @{
    id = 'jobhunt'
    age = 22
    title = @{
      ja = '22歳：社会への一歩'
      en = 'Age 22: Stepping into the World'
      zh = '22岁：步入社会'
    }
    body = @{
      ja = '学校を離れ、仕事を選ぶ時が来ました。若い力をどこに注ぎますか？'
      en = 'Leaving formal education behind, you stand before life''s occupational crossroads. Where will you invest your youthful drive?'
      zh = '离开学校后，你站在职业选择的路口。你会把年轻的热情投入哪里？'
    }
    fact = @{
      ja = '世界の若者（15～24歳）の失業率は約13%で、成人の約3倍です（ILO 2024）。仕事の足場を得ることが大切な節目です。'
      en = 'Global youth unemployment (ages 15-24) sits around 13%, three times that of older adults (ILO 2024). Landing a career foothold is a pivotal milestone.'
      zh = '全球15至24岁青年的失业率约为13%，是成年人的三倍（ILO，2024）。找到职业立足点是重要的一步。'
    }
    choices = @(
      @{
        id = 'office_career'
        label = @{
          ja = '企業の事務職や公務員を目指す'
          en = 'Pursue professional employment in corporate offices or civil service'
          zh = '争取公司办公室或公务员职位'
        }
        sub = @{ ja = '安定収入、知性 +6';  en = 'Stable income, Smarts +6';  zh = '稳定收入，智力 +6' }
        apply = { param($state)
          $state.job = 'Chuyên viên văn phòng'
          $state.jobId = 'clerk'
          $state.stats.smarts += 6
          $state.stats.wealth += 200
          return @{
            ja = '事務の仕事に就き、活気ある職場になじみました。'
            en = 'You secured an office role and adapted quickly to the energetic pace of professional life.'
            zh = '你获得了一份办公室工作，很快适应了忙碌的职场节奏。'
          }
        }
      }
      @{
        id = 'skilled_craft'
        label = @{
          ja = '専門技術や職人の技能を磨く'
          en = 'Master a skilled technical trade or practical craftsmanship'
          zh = '掌握专业技术或实用手艺'
        }
        sub = @{ ja = '健康 +6、堅実な技能収入';  en = 'Health +6, Solid trade earnings';  zh = '健康 +6，稳定的技术收入' }
        apply = { param($state)
          $state.job = 'Kỹ thuật viên lành nghề'
          $state.jobId = 'mechanic'
          $state.stats.health += 6
          $state.stats.wealth += 250
          return @{
            ja = 'こつこつと腕を磨き、その仕事ぶりが信頼を集めました。'
            en = 'Through tireless hands-on dedication, your craftsmanship won widespread trust.'
            zh = '凭着不懈的实践和努力，你的手艺赢得了大家的信任。'
          }
        }
      }
    )
  }

  # Age 28: Migration Dilemma (Working Abroad vs Staying Near Family)
  migx = @{
    id = 'migx'
    age = 28
    title = @{
      ja = '28歳：移住の分かれ道'
      en = 'Age 28: The Migration Crossroads'
      zh = '28岁：移居的岔路口'
    }
    body = @{
      ja = '高所得国で働く好機が来ました。貯蓄は増えそうですが、故郷と家族を離れることになります。'
      en = 'A lucrative opportunity to work in a high-income nation arrives. It promises substantial savings, but demands leaving family and homeland behind.'
      zh = '一个去高收入国家工作的机会出现了。它能带来可观积蓄，但你必须离开家人与故乡。'
    }
    fact = @{
      ja = '国際移民は世界で2億8千万人以上（UN DESA）、家族への年間送金は6,500億ドル以上です（世界銀行）。'
      en = 'Over 280 million people live as international migrants worldwide (UN DESA), sending over $650 billion in remittances to families annually (World Bank).'
      zh = '全球有超过2.8亿国际移民（UN DESA），每年向家人汇款超过6500亿美元（世界银行）。'
    }
    choices = @(
      @{
        id = 'go_abroad'
        label = @{
          ja = '海外で働き、家族に仕送りする'
          en = 'Venture abroad to work and send remittances back to your family'
          zh = '出国工作，向家人汇款'
        }
        sub = @{ ja = '資産 +1500、知性 +8、故郷が恋しい';  en = 'Wealth +1500, Smarts +8, Homesick';  zh = '财富 +1500，智力 +8，思乡' }
        apply = { param($state)
          $state.stats.wealth += 1500
          $state.stats.smarts += 8
          $state.stats.happiness -= 4
          $state.flags.workedAbroad = $true
          return @{
            ja = '初めのホームシックを乗り越え、家族の暮らしを変える仕送りを続けました。'
            en = 'Overcoming early homesickness, you steadily sent life-changing savings back home.'
            zh = '你克服最初的思乡之苦，持续寄钱回家，改善了家人的生活。'
          }
        }
      }
      @{
        id = 'stay_home'
        label = @{
          ja = '故郷に残り、年老いる両親のそばにいる'
          en = 'Stay home to remain close to aging parents and cherished roots'
          zh = '留在家乡，陪伴渐老的父母'
        }
        sub = @{ ja = '幸福 +10、社交 +8';  en = 'Happiness +10, Social +8';  zh = '幸福 +10，社交 +8' }
        apply = { param($state)
          $state.stats.happiness += 10
          $state.stats.social += 8
          return @{
            ja = '家族との温かい夕食が、心の支えになりました。'
            en = 'Warm dinners with family kept your spirit anchored and deeply comforted.'
            zh = '与家人共进的温暖晚餐，给了你深深的安慰。'
          }
        }
      }
    )
  }

  # Age 32: Entrepreneurship vs Employment Stability
  biz = @{
    id = 'biz'
    age = 32
    title = @{
      ja = '32歳：起業への思い'
      en = 'Age 32: The Entrepreneurial Spark'
      zh = '32岁：创业的火花'
    }
    body = @{
      ja = '10年ほどの経験と少しの貯蓄があります。自分で商売を始めるか、今の安定を守るか考えます。'
      en = 'With a decade of hands-on experience and modest savings, the drive to launch your own venture calls. Do you take the leap or hold steady?'
      zh = '有了十年的实践经验和一些积蓄，你萌生了创业的念头。是大胆尝试，还是保持稳定？'
    }
    fact = @{
      ja = '中小企業は世界の企業の約90%を占め、雇用の50%以上を支えています（世界銀行）。'
      en = 'Small and medium enterprises represent about 90% of all businesses and more than 50% of employment worldwide (World Bank).'
      zh = '中小企业约占全球企业的90%，提供超过50%的就业岗位（世界银行）。'
    }
    choices = @(
      @{
        id = 'start_business'
        label = @{
          ja = '独立して、自分の事業を始める'
          en = 'Launch your independent business and become your own boss'
          zh = '独立创业，自己当老板'
        }
        sub = @{ ja = '高い利益とリスク、知性 +10';  en = 'High reward/risk, Smarts +10';  zh = '高风险高回报，智力 +10' }
        apply = { param($state)
          $success = (Test-Chance (0.65))
          $state.stats.smarts += 10
          if ($success) {
            $state.job = 'Chủ doanh nghiệp nhỏ'
            $state.jobId = 'owner'
            $state.stats.wealth += 1200
            $state.stats.happiness += 8
            return @{
              ja = '粘り強い努力が実り、店は地域に愛される存在になりました！'
              en = 'Through tireless grit, your shop flourished into a thriving neighborhood staple!'
              zh = '凭着不懈的努力，你的小店成为街坊喜爱的店铺！'
            }
          } else {
            $state.stats.wealth = [Math]::Max(0, $state.stats.wealth - 300)
            return @{
              ja = '景気悪化で店は苦戦しましたが、商売を続ける力を学びました。'
              en = 'Market downturns tested your shop, but the ordeal taught you invaluable business grit.'
              zh = '市场低迷考验着你的小店，也教会了你经营中的坚韧。'
            }
          }
        }
      }
      @{
        id = 'keep_stable'
        label = @{
          ja = '今の仕事を続け、家計の安定を守る'
          en = 'Keep your steady job and protect your family''s financial calm'
          zh = '继续稳定的工作，守住家庭财务的安宁'
        }
        sub = @{ ja = '幸福 +6、ストレス少なめ';  en = 'Happiness +6, Low stress';  zh = '幸福 +6，压力较低' }
        apply = { param($state)
          $state.stats.happiness += 6
          $state.stats.wealth += 400
          return @{
            ja = '安定した給料が、自分と家族に安心をもたらしました。'
            en = 'Steady salary brought dependable security for you and your loved ones.'
            zh = '稳定的工资为你和家人带来了可靠的保障。'
          }
        }
      }
    )
  }

  # Age 38: Mid-career Health & Wellness Awakening
  lifestyle = @{
    id = 'lifestyle'
    age = 38
    title = @{
      ja = '38歳：健康を見直す時'
      en = 'Age 38: The Midlife Wellness Awakening'
      zh = '38岁：重新重视健康'
    }
    body = @{
      ja = '長い勤務が続き、疲れや痛みを感じ始めました。若さがいつまでも続くわけではないと気づきます。'
      en = 'Lingering fatigue and aches emerge after prolonged workweeks. Your body gently signals that youth is no longer an infinite reservoir.'
      zh = '长时间工作后，疲劳和疼痛逐渐出现。身体提醒你，年轻并不是用不完的本钱。'
    }
    fact = @{
      ja = '心血管疾患、がん、糖尿病などの非感染性疾患は世界の死亡の74%を占めます（WHO）。中年期の生活習慣が将来に影響します。'
      en = 'Non-communicable diseases (cardiovascular, cancer, diabetes) account for 74% of all global deaths (WHO). Lifestyle changes in midlife add over a decade of vitality.'
      zh = '心血管疾病、癌症、糖尿病等非传染性疾病占全球死亡的74%（WHO）。中年的生活方式会影响未来健康。'
    }
    choices = @(
      @{
        id = 'healthy_change'
        label = @{
          ja = '食生活を整え、毎日運動する'
          en = 'Commit to wholesome nutrition and daily fitness training'
          zh = '坚持健康饮食和每天锻炼'
        }
        sub = @{ ja = '健康 +12、活力 +6';  en = 'Health +12, Vitality +6';  zh = '健康 +12，活力 +6' }
        apply = { param($state)
          $state.stats.health = [Math]::Min(100, $state.stats.health + 12)
          $state.stats.happiness += 6
          return @{
            ja = '体が軽くなり、毎朝を前向きに迎えられるようになりました。'
            en = 'Your body felt refreshed and light; newfound vitality fueled each morning with optimism.'
            zh = '身体轻松了许多，新的活力让你每天都充满期待。'
          }
        }
      }
      @{
        id = 'work_focus'
        label = @{
          ja = '疲れを押して、収入のために働き続ける'
          en = 'Push through the aches and keep driving hard for financial gain'
          zh = '忍着疲劳继续拼命赚钱'
        }
        sub = @{ ja = '資産 +500、健康 -6';  en = 'Wealth +500, Health -6';  zh = '财富 +500，健康 -6' }
        apply = { param($state)
          $state.stats.wealth += 500
          $state.stats.health = [Math]::Max(10, $state.stats.health - 6)
          return @{
            ja = '収入は増えましたが、眠れない夜が続いて体に負担がかかりました。'
            en = 'Earnings mounted, but weary sleepless nights began taking a noticeable toll on your body.'
            zh = '收入增加了，但疲惫和失眠开始明显损害你的身体。'
          }
        }
      }
    )
  }

  # Age 48: Eldercare and Family Devotion
  eldercare = @{
    id = 'eldercare'
    age = 48
    title = @{
      ja = '48歳：年老いた親を支える'
      en = 'Age 48: Honoring the Elders'
      zh = '48岁：照顾长辈'
    }
    body = @{
      ja = '両親が年を取り、移動や日々の暮らしに助けが必要になりました。仕事と家庭を抱えながら、どう支えますか？'
      en = 'Aging parents face declining mobility and chronic ailments, needing daily devotion. Balancing your own household and career, how do you tend to them?'
      zh = '父母年迈，行动和日常生活都需要帮助。你还要兼顾自己的家庭与事业，会怎样照顾他们？'
    }
    fact = @{
      ja = '40～50代の「サンドイッチ世代」は、育つ子どもと弱る親を同時に支え、心と家計の二重の負担を担います（OECD）。'
      en = 'The "Sandwich Generation" in their 40s-50s globally supports both maturing children and frail parents, shouldering double emotional and fiscal weight (OECD).'
      zh = '四五十岁的“夹心一代”同时抚养孩子和照顾年迈父母，承担双重的情感与经济压力（OECD）。'
    }
    choices = @(
      @{
        id = 'care_at_home'
        label = @{
          ja = '両親を家に迎え、自分で世話をする'
          en = 'Welcome your parents into your home to personally care for them'
          zh = '接父母到家中，亲自照料'
        }
        sub = @{ ja = '幸福 +14、家族の絆 +12';  en = 'Happiness +14, Family Bond +12';  zh = '幸福 +14，亲情 +12' }
        apply = { param($state)
          $state.stats.happiness += 14
          $state.stats.social += 12
          return @{
            ja = '体は疲れても、両親の穏やかな笑顔が何よりの慰めになりました。'
            en = 'Though physically wearying, seeing your parents'' peaceful smiles brought boundless solace.'
            zh = '虽然身体劳累，父母安宁的笑容却带来无尽的慰藉。'
          }
        }
      }
      @{
        id = 'medical_aid'
        label = @{
          ja = '訪問看護や専門の介護を利用する'
          en = 'Hire professional in-home nursing and specialized medical care'
          zh = '聘请专业上门护理和医疗照护'
        }
        sub = @{ ja = '資産 -400、専門のケア';  en = 'Wealth -400, Professional care';  zh = '财富 -400，专业照护' }
        apply = { param($state)
          $state.stats.wealth = [Math]::Max(0, $state.stats.wealth - 400)
          $state.stats.social += 6
          return @{
            ja = '専門家の支えで両親の苦痛が和らぎ、仕事も続けられました。'
            en = 'Professional medical care alleviated their suffering while keeping your career afloat.'
            zh = '专业照护减轻了父母的痛苦，也让你能够继续工作。'
          }
        }
      }
    )
  }

  # Age 68: Community Legacy & Mentorship
  legacy = @{
    id = 'legacy'
    age = 68
    title = @{
      ja = '68歳：経験を生かす日々'
      en = 'Age 68: The Venerable Elder'
      zh = '68岁：受人尊敬的长者'
    }
    body = @{
      ja = '仕事中心の日々を終え、退職生活も落ち着いてきました。豊富な人生経験を持つ今、どのように過ごしますか？'
      en = 'With your working years behind you, you possess a treasure trove of lived experience. How do you choose to spend these golden days?'
      zh = '忙碌的工作岁月已经过去，退休生活也渐入佳境。拥有丰富阅历的你，会如何度过这些日子？'
    }
    fact = @{
      ja = '長寿研究では、指導や奉仕を続ける高齢者は、長生きし認知機能も保ちやすい傾向が示されています。'
      en = 'Harvard longevity studies show elders who actively mentor or volunteer live 20% longer with substantially lower cognitive decline.'
      zh = '长寿研究显示，积极指导年轻人或参与志愿服务的老人，往往寿命更长、认知衰退风险更低。'
    }
    choices = @(
      @{
        id = 'mentor_youth'
        label = @{
          ja = '若者を導き、地域でボランティアをする'
          en = 'Mentor the young and volunteer in community neighborhood projects'
          zh = '指导年轻人，参与社区志愿活动'
        }
        sub = @{ ja = '幸福 +16、社交 +14';  en = 'Happiness +16, Social +14';  zh = '幸福 +16，社交 +14' }
        apply = { param($state)
          $state.stats.happiness += 16
          $state.stats.social += 14
          return @{
            ja = 'あなたの親切と穏やかな助言が、悩める若者たちを支えました。'
            en = 'Neighbors cherished your kindness; your gentle counsel guided many struggling youths.'
            zh = '邻里珍惜你的善意，温和的建议帮助了许多迷茫的年轻人。'
          }
        }
      }
      @{
        id = 'leisure_travel'
        label = @{
          ja = '花を育て、景色や旅行をゆっくり楽しむ'
          en = 'Enjoy serene leisure, tending lush garden flowers and scenic travels'
          zh = '悠闲地种花、散步和旅行'
        }
        sub = @{ ja = '穏やかな心、健康 +8';  en = 'Tranquility, Health +8';  zh = '心境平和，健康 +8' }
        apply = { param($state)
          $state.stats.health = [Math]::Min(100, $state.stats.health + 8)
          $state.stats.happiness += 12
          return @{
            ja = '花の香りとゆったりした散歩が、心に安らぎをもたらしました。'
            en = 'Fragrant flowerbeds and leisurely strolls bathed your spirit in tranquil joy.'
            zh = '芬芳的花园和悠闲的散步，让你的心灵充满宁静的喜悦。'
          }
        }
      }
    )
  }

  # Age 80: Final Will & Peaceful Heritage
  will = @{
    id = 'will'
    age = 80
    title = @{
      ja = '80歳：未来に残すもの'
      en = 'Age 80: The Lasting Heritage'
      zh = '80岁：留下的传承'
    }
    body = @{
      ja = '地上で80年を過ごしました。喜びも涙もある人生を振り返り、次の世代に何を残したいですか？'
      en = 'Eighty years upon this Earth. Looking back upon a complete human existence of joy, tears, and resilience. What final gift do you leave behind?'
      zh = '在世间走过八十年，回望充满欢笑、泪水与坚韧的一生，你想给后人留下什么？'
    }
    fact = @{
      ja = '80歳を迎えるまでには、多くの困難や病気を乗り越えています。長い人生を歩んだこと自体が大きな達成です。'
      en = 'Only about a third of babies born in developing nations live to celebrate their 80th birthday. Reaching age 80 is humanity''s grandest triumph.'
      zh = '走到八十岁，需要跨越许多困难与疾病。能走完这段漫长旅程，本身就是巨大的成就。'
    }
    choices = @(
      @{
        id = 'family_harmony'
        label = @{
          ja = '子孫に思いやりと家族の和を伝える'
          en = 'Leave a message of harmony, love, and unity for those who follow'
          zh = '给后人留下关爱、和睦与团结的嘱托'
        }
        sub = @{ ja = '心の安らぎ +20';  en = 'Complete Peace +20';  zh = '内心安宁 +20' }
        apply = { param($state)
          $state.stats.happiness += 20
          return @{
            ja = '大切な人々の愛に包まれ、心からの安らぎを感じました。'
            en = 'Surrounded by the love of people dear to you, you felt total peace in your heart.'
            zh = '被亲人的爱包围着，你的心中充满安宁。'
          }
        }
      }
      @{
        id = 'donate_cause'
        label = @{
          ja = '貯蓄の一部を、困っている子の奨学金にする'
          en = 'Endow a portion of savings to support scholarships for needy children'
          zh = '拿出部分积蓄，资助困难儿童求学'
        }
        sub = @{ ja = '尊い遺産、幸福 +22';  en = 'Noble Legacy, Happiness +22';  zh = '高尚的传承，幸福 +22' }
        apply = { param($state)
          $state.stats.happiness += 22
          $state.stats.social += 15
          return @{
            ja = 'あなたが学びの機会を与えた子どもたちの心に、その名が残りました。'
            en = 'Your name lived on in the bright eyes of schoolchildren whose futures you illuminated.'
            zh = '你帮助照亮了孩子们的未来，他们会一直记得你的名字。'
          }
        }
      }
    )
  }
}

