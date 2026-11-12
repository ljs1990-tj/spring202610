<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Document</title>
        <script src="https://code.jquery.com/jquery-3.7.1.js"
            integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>
        <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5e03846a5bae385cef3b2da33124bd8d&libraries=services"></script>
        <style>
            table,
            tr,
            td,
            th {
                border: 1px solid black;
                border-collapse: collapse;
                padding: 5px 10px;
                text-align: center;
            }

            th {
                background-color: beige;
            }

            tr:nth-child(even) {
                background-color: azure;
            }
        </style>
    </head>

    <body>
        <div id="app">
            <!-- html 코드는 id가 app인 태그 안에서 작업 -->
            <div>
                <select v-model="category" @change="fnSearch">
                    <option value="">:: 선택 ::</option>
                    <option value="MT1">대형마트</option>
                    <option value="CS2">편의점</option>
                    <option value="PS3">어린이집, 유치원</option>
                    <option value="SC4">학교</option>
                    <option value="AC5">학원</option>
                    <option value="PK6">주차장</option>
                    <option value="OL7">주유소, 충전소</option>
                    <option value="SW8">지하철역</option>
                    <option value="BK9">은행</option>
                    <option value="CT1">문화시설</option>
                    <option value="AG2">중개업소</option>
                    <option value="PO3">공공기관</option>
                    <option value="AT4">관광명소</option>
                    <option value="AD5">숙박</option>
                    <option value="FD6">음식점</option>
                    <option value="CE7">카페</option>
                    <option value="HP8">병원</option>
                    <option value="PM9">약국</option>
                </select>
            </div>
            <hr>
            <div id="map" style="width:500px;height:400px;"></div>
        </div>
    </body>

    </html>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 변수 - (key : value)
                    infowindow: null,
                    map: null,
                    ps: null,
                    category : "",
                    markerList : []
                };
            },
            methods: {
                // 함수(메소드) - (key : function())
                fnMapInit: function () {
                    // 마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
                    this.infowindow = new kakao.maps.InfoWindow({ zIndex: 1 });

                    var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
                        mapOption = {
                            center: new kakao.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
                            level: 3 // 지도의 확대 레벨
                        };

                    // 지도를 생성합니다    
                    this.map = new kakao.maps.Map(mapContainer, mapOption);

                    // 장소 검색 객체를 생성합니다
                    this.ps = new kakao.maps.services.Places(this.map);

                    // 카테고리로 은행을 검색합니다
                    // this.ps.categorySearch('CS2', this.placesSearchCB, { useMapBounds: true });
                },
                placesSearchCB: function (data, status, pagination) {
                    if (status === kakao.maps.services.Status.OK) {
                        for (var i = 0; i < data.length; i++) {
                            this.displayMarker(data[i]);
                        }
                    }
                },
                displayMarker: function (place) {
                    var marker = new kakao.maps.Marker({
                        map: this.map,
                        position: new kakao.maps.LatLng(place.y, place.x)
                    });
                    this.markerList.push(marker);
                    // 마커에 클릭이벤트를 등록합니다
                    kakao.maps.event.addListener(marker, 'click', function () {
                        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
                        this.infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
                        this.infowindow.open(this.map, marker);
                    });
                },
                fnSearch(){
                    let self = this;
                    for(let i=0; i<self.markerList.length; i++){
                        self.markerList[i].setMap(null); // 마커를 지도에서 제거
                    }
                    self.markerList = [];
                    self.ps.categorySearch(self.category, self.placesSearchCB, { useMapBounds: true });
                }

            }, // methods
            mounted() {
                // 처음 시작할 때 실행되는 부분
                let self = this;
                self.fnMapInit();
            }
        });

        app.mount('#app');
    </script>