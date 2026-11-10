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
            <h3>제목 : {{info.title}}</h3>
            <h3>작성자 : {{info.userId}} | 조회수 : {{info.cnt}}</h3>
            <hr>
            <h4>내용</h4>
            <img v-for="item in fileList" :src="item.filePath">
            <div v-html="info.contents"></div>
        </div>
        <hr>
        <div v-if="sessionId == info.userId || sessionRole == 'A' ">
            <button @click="fnView">수정</button>
            <button @click="fnRemove">삭제</button>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                sessionId : "${sessionId}",
                sessionName : "${sessionName}",
                sessionRole : "${sessionRole}",

                boardNo : "${boardNo}",
                info : {},
                fileList : []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnInfo : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo
                };
                $.ajax({
                    url: "view.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.info = data.info;
                        self.fileList = data.fileList;
                    }
                });
            },
            fnView : function(){
                let self = this;
                pageChange("edit.do", {boardNo : self.boardNo});
            },
            fnRemove : function () {
                let self = this;
                let param = {
                    boardNo : self.boardNo
                };
                $.ajax({
                    url: "remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert(data.message);
                        if(data.result == "success"){
                            location.href = "list.do";
                        }
                        
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            console.log(self.boardNo);
            self.fnInfo();
        }
    });

    app.mount('#app');
</script>