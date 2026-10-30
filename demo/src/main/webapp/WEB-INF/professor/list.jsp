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
            검색어 : <input v-model="keyword" @keyup.enter="fnList"> 
            <button @click="fnList">검색</button>
        </div>
        <div>학과 : 
            <select v-model="deptNo" @change="fnList">
                <option value="">:: 전체 ::</option>
                <option v-for="item in deptList" :value="item.deptNo">{{item.dName}}</option>
            </select>
            || 
            직급 : 
            <select v-model="position" @change="fnList">
                <option value="">:: 전체 :: </option>
                <option value="정교수">정교수</option>
                <option value="조교수">조교수</option>
                <option value="전임강사">전임강사</option>
            </select>
        </div>
        <hr>
        <div>
			<table>
				<tr>
					<th>번호</th>
					<th>이름</th>
					<th>직급</th>
                    <th>급여</th>
					<th>이메일</th>
                    <th>학과</th>
                    <th>삭제</th>
				</tr>
				<tr v-for="item in list">
					<td>{{item.profNo}}</td>
					<td>
                        <a href="javascript:;" @click="fnView(item.profNo)">{{item.name}}</a>
                    </td>
					<td>{{item.position}}</td>
                    <td>{{item.pay}}</td>
					<td>{{item.email}}</td>
                    <td>{{item.dName}}</td>
                    <td><button @click="fnRemove(item.profNo)">삭제</button></td>
				</tr>
                <tr v-if="list.length == 0">
                    <td colspan="7">조건에 맞는 데이터가 없습니다.</td>
                </tr>
			</table>
		</div>
        <div>
            <a href="add.do"><button>교수추가</button></a>
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
                keyword : "",
                deptList : [],
                deptNo : "",
                position : ""
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnList : function () {
                let self = this;
                let param = {
                    keyword : self.keyword,
                    deptNo : self.deptNo,
                    position : self.position
                };
                $.ajax({
                    url: "http://localhost:8080/professor/list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log(data);
                        self.list = data.list;
                        self.deptList = data.deptList;
                    }
                });
            },
            fnRemove : function(profNo){
                let self = this;
				let param = {
                    profNo : profNo
                };
				$.ajax({
				    url: "http://localhost:8080/professor/remove.dox",
				    dataType: "json",
				    type: "POST",
				    data: param,
				    success: function (data) {
						alert("삭제 됨!");
						self.fnList();
						
				    }
				});
            },
            fnView : function(profNo){
                // view.do 페이지 이동
                pageChange("view.do", {profNo : profNo});
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