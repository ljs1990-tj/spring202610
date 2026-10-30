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
            급여등급 : 
            <select v-model="grade" @change="fnList">
                <option value="">:: 전체 ::</option>
                <!-- <option v-for="item in gradeList" :value="item.grade">{{item.grade}}등급</option> -->
                <option value="1">1등급</option>
                <option value="2">2등급</option>
                <option value="3">3등급</option>
                <option value="4">4등급</option>
                <option value="5">5등급</option>
            </select>
        </div>
        <hr>
        <div>
            <table>
                <tr>
                    <th>사번</th>
                    <th>이름</th>
                    <th>직급</th>
                    <th>급여</th>
                    <th>급여등급</th>
                    <th>삭제</th>
                </tr>
                <tr v-for="item in list">
                    <td>{{item.empNo}}</td>
                    <td>
                        <a href="javascript:;" @click="fnView(item.empNo)">{{item.eName}}</a>
                    </td>
                    <td>{{item.job}}</td>
                    <td>{{item.sal}}</td>
                    <td>{{item.grade}}</td>
                    <td><button @click="fnRemove(item.empNo)">삭제</button></td>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                list : [],
                gradeList : [],
                grade : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {
                    grade : self.grade
                };
                $.ajax({
                    url: "http://localhost:8080/emp/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.list = data.list;
                        self.gradeList = data.gradeList;
                    }
                });
            },
            fnRemove : function(empNo){
                let self = this;
                let param = {
                    empNo : empNo
                };
                $.ajax({
                    url: "http://localhost:8080/emp/remove.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        alert("삭제 됨!");
                        self.fnList();
                    }
                });
            },
            fnView : function(empNo){
                pageChange("view.do", {empNo : empNo});
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
        }
    });

    app.mount('#app');
</script>