from bs4 import BeautifulSoup
from urllib.request import urlopen
import time
from seleniumwire import webdriver
from selenium.webdriver.chrome.options import Options
import math
import pandas as pd
from selenium.webdriver.common.keys import Keys


chrome_options = Options()
chrome_options.add_experimental_option("detach", True)
chrome_options.add_experimental_option("excludeSwitches", ["enable-logging"])
search_key = '성남 스터디카페' #원하는 검색어

review_data = []

def scrollDown(driver, scrollDown_num=10): #스크롤 내리는 코드
    body = driver.find_element_by_css_selector('body')
    body.click()
    for i in range(100):
        time.sleep(0.1)
        body.send_keys(Keys.PAGE_DOWN)

url = "https://map.naver.com/v5/search/" + search_key #네이버 플레이스 검색
driverPath = "chromedriver.exe" #절대경로
driver = webdriver.Chrome(driverPath, options=chrome_options)
driver.implicitly_wait(5) #로딩까지 기다리기 위해 implicitly_wait와 sleep 사용
driver.get(url) #드라이버로 받은 주소를 실행
time.sleep(3)
driver.switch_to_frame('searchIframe') # 네이버플레이스 맨 왼쪽 장소를 보여주는 프레임
len(driver.find_elements_by_partial_link_text('광고'))

page_cnt = 0
current_page = driver.page_source
soup = BeautifulSoup(current_page, 'html.parser') #html 로드
if len(soup.select('#app-root > div > div > div._2ky45 > a')) == 7: #페이지 수 체크
    while True:
        current_page = driver.page_source
        soup = BeautifulSoup(current_page, 'html.parser') #html 로드
        if page_cnt >= 3 and int(driver.find_element_by_css_selector('#app-root > div > div > div._2ky45 > a:nth-child(4)').text) == page_cnt:
            page_cnt += 2
            break
        page_cnt += 1
        next_page = driver.find_element_by_css_selector('#app-root > div > div > div._2ky45 > a:nth-child(7) > svg') #
        next_page.click()
        time.sleep(1)
else:
    page_cnt = len(soup.select('#app-root > div > div > div._2ky45 > a')) - 2                
driver.get(url) #페이지 체크 후 다시 원래 페이지로
time.sleep(5)
current_page_cnt = 1
for i in range(page_cnt):
    driver.switch_to_frame('searchIframe')
    ad_cnt = len(driver.find_elements_by_partial_link_text('광고'))# 광고가 붙어있는 리스트는 중복되므로 건너뛰기 위해 카운트
    body = driver.find_element_by_css_selector('body')
    body.click()
    scrollDown(driver) #스크롤 내려서 모두 로드
    time.sleep(3)
    current_page = driver.page_source
    soup = BeautifulSoup(current_page, 'html.parser') #html 로드
    list_cnt = len(soup.select('#_pcmap_list_scroll_container > ul > li'))
    current_place = 0 + ad_cnt
    print(page_cnt)
    print(list_cnt)  
    driver.switch_to_default_content()   
    for j in range(ad_cnt, list_cnt): #페이지당 장소 최대 50개
        driver.switch_to_frame('searchIframe') # 해당 장소 리뷰 크롤링이 끝나면 프레임 전환
        current_page = driver.page_source
        soup = BeautifulSoup(current_page, 'html.parser') #html 로드
        place_list = driver.find_element_by_xpath(f'/html/body/div[3]/div/div/div[1]/ul/li[{j+1}]/div[2]/a[1]')  # 해당 장소의 xpath 경로
        place_name = soup.select_one(f'li:nth-child({j+1}) > div._3ZU00._1rBq3 > a:nth-child(1) > div > div > span').text
        place_list.click() #클릭
        time.sleep(2) #페이지 로드를 기다림
        driver.switch_to_default_content() 
        driver.switch_to_frame('entryIframe') # 장소의 상세한 정보를 나타내는 두번째 프레임
        current_page = driver.page_source
        soup = BeautifulSoup(current_page, 'html.parser') #html 로드
        review_check = soup.select_one('#app-root > div > div > div.place_detail_wrapper > div.place_section.no_margin.GCwOh > div > div > div._3XpyR._2z4r0 > div._1kUrA > span > a').text
        #방문자 리뷰가 존재하는지 체크(존재하지 않거나 블로그리뷰만 있으면 다음 장소로 넘어감)
        if '방문자리뷰' in review_check:
            review_list = driver.find_element_by_partial_link_text('리뷰') #리뷰 버튼을 찾아서 클릭
            review_list.click()
            time.sleep(5) #페이지 로드를 기다림
            review_cnt = int(driver.find_element_by_class_name('place_section_count').text) #글로 된 리뷰 개수 확인
            current_page = driver.page_source
            soup = BeautifulSoup(current_page, 'html.parser') #html 로드
            h2_tag = soup.select('h2.place_section_header') 
            text_review_exists = 0
            for n in range(len(h2_tag)): #글 리뷰가 있는지 확인
                if ('사진 리뷰' not in h2_tag[n] and '별점 리뷰' not in h2_tag[n]): #사진이나 별점리뷰만 존재하면 다음 장소로 넘어감
                    text_review_exists = 1
                    break   
            if text_review_exists == 1:
                if review_cnt % 10 == 0: #더보기당 리뷰 10개
                    more_cnt =  review_cnt//10 - 1
                else:
                    more_cnt =  review_cnt//10
                body = driver.find_element_by_css_selector('body')
                body.click()    
                for k in range(more_cnt):  #더보기 개수 만큼 스크롤 내리고 클릭        
                    scrollDown(driver)
                    more_review = driver.find_element_by_class_name('_3iTUo') #버튼 경로
                    more_review.click()                    
                scrollDown(driver)    
                current_page = driver.page_source
                soup = BeautifulSoup(current_page, 'html.parser') #모든 리뷰를 로드                  
                for k in range(review_cnt):
                    if soup.select_one(f'li:nth-child({k+1}) > div._1Z_GL > div.PVBo8 > a > span') != None: #긴 리뷰는 펼치기 버튼이 있으므로 찾아서 누르기
                        if(len(soup.select(f'li:nth-child({k+1}) > div._1Z_GL > div.PVBo8 > a > span'))) == 2:
                            driver.find_element_by_css_selector(f'li:nth-child({k+1}) > div._1Z_GL > div.PVBo8 > a').send_keys(Keys.ENTER) #클릭 함수가 안될 경우 엔터 키를 보냄 
                            current_page = driver.page_source
                            soup = BeautifulSoup(current_page, 'html.parser')  #리뷰를 펼치고 다시 로드                      
                            time.sleep(1)                                         
                        review_text = soup.select_one(f'li:nth-child({k+1}) > div._1Z_GL > div.PVBo8 > a > span').text.strip() #텍스트 추출 
                        star_rate = soup.select_one(f'li:nth-child({k+1}) > div._1Z_GL > div._1ZcDn > div._3D_HC > span._2tObC').text #별점 추출
                        review_data.append((place_name, review_text, star_rate)) #리스트로 저장
                        time.sleep(0.1)           
        text_review_exists = 0  #다음 장소를 위해 글 리뷰 여부 초기화
        current_place += 1               
        driver.switch_to_default_content() #프레임 초기화
        time.sleep(2)
    df = pd.DataFrame(review_data, columns = ['장소명', '리뷰', '별점']) #데이터 프레임으로 만들어 엑셀에 저장
    df.to_csv(f'place_review{i}.csv', encoding='utf-8-sig', index=False)
driver.switch_to_frame('searchIframe')        
next_page = driver.find_element_by_css_selector('#app-root > div > div > div._2ky45 > a:nth-child(7) > svg') #페이지 넘기기
next_page.click()
current_page_cnt += 1 


df = pd.DataFrame(review_data, columns = ['장소명', '리뷰', '별점']) #데이터 프레임으로 만들어 엑셀에 저장
df.to_csv('place_review.csv', encoding='utf-8-sig', index=False)

'''
time.sleep()은 너무 빠른 크롤링으로 인해 크롤링이 막히거나 페이지 로드가 완전히 되지 않아 데이터를 추출하지 못하고 중간에 종료되는걸 막기 위함
페이지 넘기는 코드 추가 예정
'''