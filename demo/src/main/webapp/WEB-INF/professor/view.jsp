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
        <div>교수번호 : {{info.profNo}}</div>
        <div>이름 : {{info.name}}</div>
        <hr>
        <button @click="fnRemove">삭제</button>
        <button @click="fnEdit">수정</button>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                profNo : "${profNo}",
                info : {}
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    profNo : self.profNo
                };
                $.ajax({
                    url: "http://localhost:8080/professor/info.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                    }
                });
            },
            fnRemove : function () {
                let self = this;
                let param = {
                    profNo : self.profNo
                };
                $.ajax({
                    url: "http://localhost:8080/professor/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("삭제 됨!");
                        location.href="list.do";
                    }
                });
            },
            fnEdit : function(){
                let self = this;
                pageChange("edit.do", {profNo : self.profNo});
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnInfo();
        }
    });

    app.mount('#app');
</script>