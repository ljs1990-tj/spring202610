<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <style>
        table, tr, td, th{
            border : 1px solid black;
            border-collapse: collapse;
            padding : 5px 10px;
            text-align: center;
        }
        th{
            background-color: beige;
        }
        tr:nth-child(even){
            background-color: azure;
        }
    </style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div>
            <select v-model="si" @change="fnGuList">
                시 : <option value="">:: 선택 ::</option>
                <option :value="item.si" v-for="item in siList">{{item.si}}</option>
            </select>
            <select v-model="gu" @change="fnDongList">
                구 : <option value="">:: 선택 ::</option>
                <option :value="item.gu" v-for="item in guList">{{item.gu}}</option>
            </select>
            <select v-model="dong" @change="fnGetWeather">
                동 : <option value="">:: 선택 ::</option>
                <option :value="item" v-for="item in dongList">{{item.dong}}</option>
            </select>
        </div>
        
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                siList : [],
                guList : [],
                dongList : [],
                si : "",
                gu : "",
                dong : {}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnSiList : function () {
                let self = this;
                self.dongList = [];
                self.dong = "";

                let param = {};
                $.ajax({
                    url: "http://localhost:8080/area/si.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.siList = data.siList;
                    }
                });
            },
            fnGuList : function () {
                let self = this;
                self.guList = [];
                self.gu = "";
                self.dongList = [];
                self.dong = "";
                let param = {
                    si : self.si
                };
                $.ajax({
                    url: "http://localhost:8080/area/gu.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.guList = data.guList;
                    }
                });
            },
            fnDongList : function () {
                let self = this;
                self.dongList = [];
                self.dong = "";
                let param = {
                    si : self.si,
                    gu : self.gu
                };
                $.ajax({
                    url: "http://localhost:8080/area/dong.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.dongList = data.dongList;
                    }
                });
            },

            fnGetWeather : function () {
                let self = this;
                let param = {
                    serviceKey : decodeURIComponent("26Jt6WG3w3Ea4on0SOc67nMTWJlJ0CwWzH2XHxhuBHYzBkwABUcem88lB39hBrLvCcp7P%2BDMdLp0nBvkx9QUYQ%3D%3D"),
                    pageNo : 1,
                    numOfRows : 1000,
                    dataType : "JSON",
                    base_date : "20261113",
                    base_time : "0900",
                    nx : self.dong.nx,
                    ny : self.dong.ny

                };
                $.ajax({
                    url: "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getUltraSrtNcst",
                    dataType: "json",
                    type: "GET",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        let items = data.response.body.items.item;
                        for(let i=0; i<items.length; i++){
                            let item = items[i];
                            if(item.category == 'T1H'){
                                // 기온에 대한 처리, 단위 : ℃
                                console.log("기온 ==> ", item.obsrValue);
                            }
                            if(item.category == 'RN1'){
                                // 강수에 대한 처리, 단위 : mm
                                console.log("1시간 강수량 ==> ", item.obsrValue);
                            }
                            if(item.category == 'PTY'){
                                // 강수량에 대한 처리
                                // 없음(0), 비(1), 비/눈(2), 눈(3), 소나기(4), 빗방울(5), 빗방울눈날림(6), 눈날림(7) 
                                console.log("강수형태 ==> ", item.obsrValue);
                            }
                        }
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnSiList();
            // self.fnGetWeather();
        }
    });

    app.mount('#app');
</script>